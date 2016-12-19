#!/bin/bash

export VERSIONS="2.39.20161219.0054" # "2.39.20161219.0054 2.39.20141222.0545"

if [ "$TARGET" != trusty -a "$TARGET" != precise ]; then
  TARGET=trusty # precise #
fi

PPA_EXT="-1~${TARGET}~ppa7"

function to_debian_version() {
  echo "$1"
}

function to_package_name() {
  echo "graphviz"
}

function to_folder_name() {
  PKG="$(to_debian_version "$1")"
  BIN="$(to_package_name "$1")"
  echo "${BIN}-${PKG}"
}

function to_archive_name() {
  PKG="$(to_debian_version "$1")"
  BIN="$(to_package_name "$1")"
  echo "${BIN}_${PKG}"
}
