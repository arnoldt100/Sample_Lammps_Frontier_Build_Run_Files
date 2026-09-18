# Introduction.  

This package provides sample build and run files for LAMMPS 
on OLCF's Frontier supercomputer. 

There are 3 steps:

* Satisfying prerequisites
* Building LAMMPS
* Runnning a sample configuration


## Prerequisites
These examples were tested in a bash shell. If your preferred
shell is not bash, you may need to modify some of the
files to your shell environment. The bash scripts are simple
and adapting them should be easy. 

One will need your project ID to configure
the batch files to run the sample configurations. 

Lastly, one needs a LAMMPS source. This package builds LAMMPS
using CMake.

## Prerequisites
(1) The first step is to modify the file `lep.lammps.sh` to point to your LAMMPS
src package. This file when sourced sets the environmental variables

    LEP_TOP_LEVEL
    LEP_LAMMPS_ROOT


The environmnetal LEP\_TOP\_LEVEL points the the top level of this working git
repository.

The environmnetal LEP\_LAMMPS\_ROOT points the the top level of yours LAMMPS
source.

To get a LAMMPS source package, run the following command inside this package 
src diirectory.

    git clone git@github.com:lammps/lammps.git

Then modify `LEP_LAMPS_ROOT` to point to `${LEP_TOP_LEVEL}/src/lammps`.

(2) from within this package top level  source the file `lep.lammps.sh'

    source ./lep.lammps.sh



## Build LAMMPS

## Sample Run Configurations 
