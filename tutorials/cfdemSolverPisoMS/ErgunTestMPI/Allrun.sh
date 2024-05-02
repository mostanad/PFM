#!/bin/bash

#===================================================================#
# allrun script for testcase as part of test routine
# run settlingTest
# Christoph Goniva - Sept. 2010
#===================================================================#

#- define variables
casePath="$(dirname "$(readlink -f ${BASH_SOURCE[0]})")"
pizzaPath="$CFDEM_PIZZA_DIR"
postproc="false"
nrPostProcProcessors=2

# check if mesh was built
if [ -d "$casePath/CFD/constant/polyMesh/boundary" ]; then
    echo "mesh was built before - using old mesh"
else
    echo "mesh needs to be built"
    cd $casePath/CFD
    blockMesh
fi

#- run parallel CFD-DEM in new terminal
gnome-terminal --title='cfdemSolverPisoMS ErgunTestMPI CFD'  -e "bash $casePath/parCFDDEMrun.sh"

if [ $postproc == "true" ]
  then

    #- keep terminal open (if started in new terminal)
    echo "simulation finisehd? ...press enter to proceed"
    read

    #- get VTK data from liggghts dump file
    cd $casePath/DEM
    python $pizzaPath/pizza.py -f pizzaScriptRestart

    #- get VTK data from CFD sim
    cd $casePath/CFD
    #foamToVTK                                                   #- serial run of foamToVTK
    source $CFDEM_PROJECT_DIR/etc/functions.sh                   #- include functions
    pseudoParallelRun "foamToVTK" $nrPostProcProcessors          #- pseudo parallel run of foamToVTK

    #- start paraview
    paraview

    #- keep terminal open (if started in new terminal)
    echo "...press enter to clean up case"
    echo "press Ctr+C to keep data"
    read

    #- clean up case
    echo "deleting data at: $casePath"
    rm -r $casePath/CFD/0.*
    rm -r $casePath/CFD/VTK
    rm -r $casePath/CFD/couplingFiles/*
    rm -r $casePath/DEM/post/*
    rm -r $casePath/DEM/log.*
    rm -r $casePath/log_*
    echo "done"

fi
