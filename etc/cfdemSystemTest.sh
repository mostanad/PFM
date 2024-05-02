#!/bin/bash

#===================================================================#
# sytsem settings test routine for cfdem project
# Christoph Goniva - May. 2011, DCS Computing GmbH
#===================================================================#

#- include functions
source $CFDEM_PROJECT_DIR/etc/functions.sh

#- show gcc settings
checkGPP="true"

#- sys check for add on
checkAddOn="false"

#- system settings
printHeader

echo "*********************************"
echo "CFDEM(R)coupling system settings:"
echo "*********************************"

echo "CFDEM_VERSION=$CFDEM_VERSION"
echo "couple to OF_VERSION=$WM_PROJECT_VERSION"
echo "compile option=$WM_COMPILE_OPTION"

echo
echo "check if paths are set correctly"
checkDirComment "$CFDEM_PROJECT_DIR" '$CFDEM_PROJECT_DIR' "yes"
checkDirComment "$CFDEM_PROJECT_USER_DIR" '$CFDEM_PROJECT_USER_DIR' "no"
checkDirComment "$CFDEM_SRC_DIR" '$CFDEM_SRC_DIR' "yes"
checkDirComment "$CFDEM_SOLVER_DIR" '$CFDEM_SOLVER_DIR' "yes"
checkDirComment "$CFDEM_TUT_DIR" '$CFDEM_TUT_DIR' "yes"
checkDirComment "$CFDEM_LIGGGHTS_SRC_DIR" '$CFDEM_LIGGGHTS_SRC_DIR' "yes"
checkEnvComment "$CFDEM_LIGGGHTS_BIN_DIR" '$CFDEM_LIGGGHTS_BIN_DIR' "yes"
checkDirComment "$CFDEM_LPP_DIR" '$CFDEM_LPP_DIR' "yes"
checkDirComment "$CFDEM_ADD_LIBS_DIR" '$CFDEM_ADD_LIBS_DIR' "yes"
checkDirComment "$CFDEM_TEST_HARNESS_PATH" '$CFDEM_TEST_HARNESS_PATH' "no"
echo ""

echo "library names"
echo '$CFDEM_LIB_NAME = '"$CFDEM_LIB_NAME"
echo '$PATH = '"$PATH"
echo '$LD_LIBRARY_PATH = '"$LD_LIBRARY_PATH"
echo '$WM_NCOMPPROCS = '"$WM_NCOMPPROCS"

echo "*******************"


if [ $checkGPP == "true" ]
  then
    echo "g++:"
    which g++
    g++ --version

    echo "gcc:"
    which gcc
    gcc --version

    echo "mpic++:"
    which mpic++
    mpic++ --version

    echo "mpirun:"
    which mpirun
    mpirun --version
fi

if [ $checkAddOn == "true" ]
  then
    echo "**********************"
    echo "additional packages..."

    packageName=c3po
    filePath=$CFDEM_SRC_DIR/$packageName
    if [ $(checkDir $filePath) == "true" ]; then
        source $filePath/etc/$packageName"SystemTest.sh"
    else
        echo "$packageName does not exist."
    fi
fi
