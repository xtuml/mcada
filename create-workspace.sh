#!/bin/bash
MCOOA_VERSION=1.0.0
MARKING_VERSION=6.18.0
CIERA_VERSION=1.1.8
if [[ $# != 1 ]]; then
  echo "Usage:"
  echo "  ./create-workspace.sh <workspace>"
  exit 1
fi
echo "Preparing workspace..."
export WORKSPACE="$1"
mkdir -p $WORKSPACE/io.ciera.runtime
mkdir -p $WORKSPACE/mcooa
mkdir -p $WORKSPACE/org.xtuml.bp.ui.marking
OLD_PWD=$PWD
cd $WORKSPACE/io.ciera.runtime && unzip -q $HOME/.m2/repository/io/ciera/io.ciera.runtime/$CIERA_VERSION/io.ciera.runtime-$CIERA_VERSION.jar 
cd $WORKSPACE/mcooa && unzip -q $HOME/.m2/repository/org/xtuml/mcooa/$MCOOA_VERSION/mcooa-$MCOOA_VERSION.jar
cd $WORKSPACE/org.xtuml.bp.ui.marking && unzip -q $HOME/.m2/repository/org/xtuml/bp/org.xtuml.bp.ui.marking/$MARKING_VERSION/org.xtuml.bp.ui.marking-$MARKING_VERSION.jar
cd $OLD_PWD
$BPHOME/bridgepoint -nosplash -data $WORKSPACE -application org.eclipse.cdt.managedbuilder.core.headlessbuild -importAll $WORKSPACE
#$BPHOME/bridgepoint -nosplash -data $WORKSPACE -application org.eclipse.cdt.managedbuilder.core.headlessbuild -importAll $PWD/model/mcboj
chmod -R -w $WORKSPACE/io.ciera.runtime $WORKSPACE/mcooa $WORKSPACE/org.xtuml.bp.ui.marking
echo "Workspace set up: $WORKSPACE"
exit 0
