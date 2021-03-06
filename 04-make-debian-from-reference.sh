#!/bin/bash

set -ex

. versions.sh

SPACE=" "

for i in $VERSIONS; do
  VERSION="$(to_debian_version "$i")"
  PKG="$(to_package_name "$i")"
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
  if [ ! -e "debian-sources/$FOLDER/$FOLDER" ]; then
    if [ -f "graphviz-source/$FOLDER.tar.gz" ]; then
      mkdir -p "debian-sources/$FOLDER"
      pushd "debian-sources/$FOLDER" || exit $?
      tar -xzvf "../../graphviz-source/$FOLDER.tar.gz" || (RET=$?; rm -rf "$FOLDER"; exit $RET)
      popd || exit $?
    fi
  fi
  pushd "debian-sources/$FOLDER" || exit $?
  cd "$FOLDER"
  rm -rf debian
  mkdir -p debian || exit $?
  if [ -z "$DEBFULLNAME" ]; then export DEBFULLNAME="Jason Gross"; fi
  if [ -z "$DEBEMAIL" ]; then export DEBEMAIL="jgross@mit.edu"; fi
  EDITOR="true" dch --create -v "$VERSION$PPA_EXT" --package "$PKG" || exit $?
  sed -i s'/ (Closes: #XXXXXX)//g' debian/changelog || exit $?
  if [[ "$VERSION" == *"~"* ]]; then
    sed -i s'/UNRELEASED/'"$TARGET"'/g' debian/changelog || exit $?
  else
    sed -i s'/UNRELEASED/'"$TARGET"'/g' debian/changelog || exit $?
  fi
  cat debian/changelog | sed s'/\(graphviz .\)[^-]*/\1@VERSION@/g' > debian/changelog.in || exit $?
  mv debian debian-orig
  cp -a ../../../reference-graphviz-2.39.20141222.0545/debian ./ || exit $?
  (echo; cat debian/changelog.in) >> debian-orig/changelog.in || exit $?
  (echo; cat debian/changelog) >> debian-orig/changelog || exit $?
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  echo "${PPA_EXT}_source.changes" > debian/series
  popd
done
