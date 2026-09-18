# Introduction.  

This package provides sample build and run files for LAMMPS 
on OLCF's Frontier supercomputer. 

There are 2 steps:

* Build LAMMPS
* Run a sample configuration


## Prerequisites
These examples were tested in a bash shell. If your preferred
shell is not bash, you may need to modify some of the
files to your shell environment. The bash scripts are simple
and adapting them should be easy. 

One will need your project ID and user name to configure
the batch files to run the sample configurations. 

Lastly, one needs a LAMMPS source. This package builds LAMMPS
using CMake.

The first is to modify the file lep.lammps.sh to point to your LAMMPS
src package. This file sets the environmental variables

    LEP_TOP_LEVEL
    LEP_LAMMPS_ROOT


The environmnetal LEP\_TOP\_LEVEL points the the top level of this working git
repository.

The environmnetal LEP\_LAMMPS\_ROOT points the the top level of yours LAMMPS
source.




## Build LAMMPS

## Sample Run Configurations 
