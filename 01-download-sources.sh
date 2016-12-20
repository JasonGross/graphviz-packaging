#!/bin/bash

set -ex

. versions.sh

mkdir -p graphviz-source
cd graphviz-source

for i in $VERSIONS; do
  wget -N "http://www.graphviz.org/pub/graphviz/development/SOURCES/graphviz-$i.tar.gz" || exit $?
done
