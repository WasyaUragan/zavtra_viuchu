#!/bin/bash
# Copyright (C) 2018 FinTech
# Author Alexey Deyneko, Andrey Emelianov, Aleksand Bechkov
# Date 20.05.2020
# Build RPM package

# Usage:
# ./rpmmake.sh 
# or 
# ./rpmmake.sh '-bp --target=x86_64' and etc. options to rpmbuild 

echo "[START]"
# Set necessary variables
USER_HOME="$HOME"
if [ -d "SOURCES" ] && [ -d "SPECS" ]; then
  echo "[BUILD with existing SOURCES]"
  BUILD_TYPE="existing"
else
  BUILD_TYPE="creating"
fi
SPEC_FILE=$(find . -name '*.spec')
SPEC_NAME=$(basename $SPEC_FILE)
PROJECT=$(echo $SPEC_NAME | sed -r 's/\..+//')

echo "User home:  $USER_HOME"
echo "Build type: $BUILD_TYPE"
echo "Spec file:  $SPEC_FILE"
echo "Spec name:  $SPEC_NAME"
echo "Project:    $PROJECT"


mkdir -p /$USER_HOME/rpmbuild
rm -rf /$USER_HOME/rpmbuild/*

if [ $BUILD_TYPE == "existing" ]; then
  cp -r ./* /$USER_HOME/rpmbuild/
else
  mkdir -p /$USER_HOME/rpmbuild/SPECS
  cp $SPEC_FILE /$USER_HOME/rpmbuild/SPECS

  mkdir -p /$USER_HOME/rpmbuild/SOURCES
  SRC_TAR="/$USER_HOME/rpmbuild/SOURCES/$PROJECT.tar.gz"
  echo "Source TAR name: $SRC_TAR"
  tar --exclude='.git' \
    --exclude='.gitignore' \
    -zcf $SRC_TAR --transform "s|^./|./$PROJECT/|" ./
fi
echo "[BUILD]"

if [ "$#" -ge 1 ]; then
  rpmbuild ${@:1} /$USER_HOME/rpmbuild/SPECS/$SPEC_NAME
else
  rpmbuild -ba /$USER_HOME/rpmbuild/SPECS/$SPEC_NAME
fi
echo "[DONE BUILD]"

mkdir -p /$USER_HOME/RPMS/$PROJECT
mkdir -p /$USER_HOME/SRPMS/$PROJECT
for rpm_file_name in $(find /$USER_HOME/rpmbuild/RPMS/ -name '*.rpm'); do cp $rpm_file_name /$USER_HOME/RPMS/$PROJECT; done
for srpm_file_name in $(find /$USER_HOME/rpmbuild/SRPMS/ -name '*.rpm'); do cp $srpm_file_name /$USER_HOME/SRPMS/$PROJECT; done
echo "[DONE]"
echo "Version 4.1"

