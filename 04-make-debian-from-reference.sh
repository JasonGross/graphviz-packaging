#!/bin/bash

set -ex

. versions.sh

SPACE=" "

for i in $VERSIONS; do
  VERSION="$(to_debian_version "$i")"
  PKG="$(to_package_name "$i")"
  FOLDER="$(to_folder_name "$i")"
  ARCHIVE="$(to_archive_name "$i")"
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
  mv debian debian-orig
  cp -a ../../../reference-graphviz-2.39.20141222.0545/debian ./ || exit $?
  mv -f debian-orig/* debian/ || exit $?
  rm -r debian-orig || exit $?
  popd
done
