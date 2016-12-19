#!/bin/bash

for TARGET in trusty; do # precise; do
    export TARGET=$TARGET
    ./05-build-debian-only-source.sh && ./06-try-dput.sh
done
./bump-version.sh
