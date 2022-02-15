:: Build the example model (Microwave Oven).
@echo off

set CIERA_RUNTIME_VERSION=1.1.8
set MCADA_VERSION=0.0.1

:: check arguments
set argC=0
for %%x in (%*) do Set /A argC+=1
if %argC% NEQ 1 (

  echo "Usage:  .\build.bat <project path>"
  exit 1
)

set CLASSPATH="../bin/io.ciera.runtime-%CIERA_RUNTIME_VERSION%.jar;../bin/antlr4-runtime-4.7.1.jar;../bin/mcada-%MCADA_VERSION%-SNAPSHOT.jar"
echo %CLASSPATH%

:: prepare build space
if not EXIST gen md gen
if not EXIST gen\code_generation md gen\code_generation
if not EXIST gen\code_generation\_ada md gen\code_generation\_ada

:: prebuild
echo "Pre-building..."
set PRE_BUILD_OUT=gen\code_generation\_system.sql
python -m bridgepoint.prebuild -o %PRE_BUILD_OUT% %*
::erase %PRE_BUILD_OUT%
::pushd %1
::for /r %%a in (.) do (
::  pushd %%a
::  for %%b in (%%a) do (
::    if EXIST %%b\*.xtuml echo %%b
::    )
::  popd
::  )
::popd

::  if EXIST %%b type *.xtuml >> %~dp0\%PRE_BUILD_OUT%_1

:: run compiler
echo "Generating..."
java -cp %CLASSPATH% mcada.McadaApplication -i %PRE_BUILD_OUT% --cwd . --gendir gen/code_generation/_ada

:: prepare build space
if not EXIST gen\code_generation\build md gen\code_generation\build

:: prepare output space
if not EXIST bin md bin

:: copy source into _ada folder
copy src\* gen\code_generation\_ada

:: compile
echo "Compiling..."
cd gen\code_generation\build
gnat make ../_ada/*

:: copy executable
if EXIST microwaveove_defineoven copy microwaveoven_defineoven ..\..\..\bin

echo "Done."
exit 0
