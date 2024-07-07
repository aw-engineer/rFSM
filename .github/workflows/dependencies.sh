#!/bin/bash
set -ex

deps="luarocks libgv-lua"
versions="5.1 5.2 5.3 5.4"

for each in $versions; do
    deps="$deps lua$each liblua$each-dev "
done

sudo apt-get install -y $deps

for each in $versions; do 
    luarocks --lua-version $each install luacov --local
done
