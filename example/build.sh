#!/bin/bash

CIERA_RUNTIME_VERSION=2.6.3
MCADA_VERSION=0.0.1-SNAPSHOT

# check arguments
if [[ $# < 1 ]]; then
  echo "Usage:"
  echo "  ./build.sh <project_path>"
  exit 1
fi

CLASSPATH=~/.m2/repository/io/ciera/runtime/$CIERA_RUNTIME_VERSION/runtime-$CIERA_RUNTIME_VERSION.jar:~/.m2/repository/org/antlr/antlr4-runtime/4.7.1/antlr4-runtime-4.7.1.jar:~/.m2/repository/org/xtuml/mcada/$MCADA_VERSION/mcada-$MCADA_VERSION.jar

# prepare build space
mkdir -p gen/code_generation/_ada

# prebuild
PRE_BUILD_OUT=gen/code_generation/_system.sql
echo "Pre-building..."
python -m bridgepoint.prebuild -o $PRE_BUILD_OUT $@

# run compiler
echo "Generating..."
java -cp $CLASSPATH mcada.McadaApplication -i $PRE_BUILD_OUT --cwd . --gendir gen/code_generation/_ada

# prepare build space
mkdir -p gen/code_generation/build

# prepare output space
mkdir -p bin

# copy source into _ada folder
mkdir -p gen/code_generation/_ada
cp src/* gen/code_generation/_ada

# compile
echo "Compiling..."
cd gen/code_generation/build
gnat make ../_ada/*

# copy executable
cp microwaveoven_defineoven ../../../bin

echo "Done."
exit 0
