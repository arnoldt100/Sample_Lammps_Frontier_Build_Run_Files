# Introduction.  

This package provides sample build and run files for LAMMPS 
on OLCF's Frontier supercomputer. 

There are 3 steps:

* Satisfying prerequisites
* Building LAMMPS
* Running a sample configuration


## Prerequisites
These examples were tested in a bash shell. If your preferred
shell is not bash, you may need to modify some of the
files to your shell environment. The bash scripts are simple
and adapting them should be easy. 

One will need your project ID to configure
the batch files to run the sample configurations. 

Lastly, one needs a LAMMPS source. This package builds LAMMPS
using CMake.

(1) The first step is to modify the file `lep.lammps.sh` to point to your LAMMPS
package. This file when sourced sets the environmental variables:

    LEP_TOP_LEVEL
    LEP_LAMMPS_ROOT

The environmental variable `LEP_TOP_LEVEL` points the top level of this working git
repository.

The environmental `LEP_LAMMPS_ROOT` points the top level of yours LAMMPS
package.

To get a LAMMPS package, run the following commands:

    cd ./src
    git clone git@github.com:lammps/lammps.git
    cd ../

Then modify `LEP_LAMPS_ROOT` in file `lep.lammps.sh` to point to
`${LEP_TOP_LEVEL}/src/lammps`.
    
    export LEP_LAMMPS_ROOT="${LEP_TOP_LEVEL}/src/lammps"

(2) From within this package top level,  source the file `lep.lammps.sh'

    source ./lep.lammps.sh

It's very important to run the source command within this package top level directory or
many scripts will break.  Echoing `${LEP_LAMMPS_ROOT}` will
have the path to the LAMMPS package:

    echo ${LEP_LAMMPS_ROOT}

## Building LAMMPS

In the directory `${LEP_TOP_LEVEL}/programming_environment_configurations`
we have sample build configurations. We use `cpe_25.09_rocm_6.4.2` as an
illustrative case.

(1) Change to directory `cpe_25.09_rocm_6.4.2`:

    cd ${LEP_TOP_LEVEL}/programming_environment_configurations/cpe_25.09_rocm_6.4.2

This directory contains 2 files:

    cpe_25.09_rocm_6.4.2.sh
    configure_build_lammps.sh

Sourcing the file `cpe_25.09_rocm_6.4.2.sh` will set the programming and run enviroment.
Executing the file `configure_build_lammps.sh` will build the LAMMPS package.

(2) Set up the programming and run environment

Edit the file `configure_build_lammps.sh` by setting the environmental
variables 

    LEP_LABEL
    LEP_INSTALLATION_DIR

The variable `LEP_LABEL` can be set to any string. It is used as a label or tag to
help differentiate different build configurations. Note this variable is used 
to form unix file paths so please use alphanumeric characters and underscores. We
will form valid UNIX file paths with `LEP_LABEL`. 

The variable `LEP_INSTALLATION_DIR` sets the path to where the LAMMPS package
will be installed. No other variables need be modified for this build
configuration.  Note that variable `LEP_INSTALLATION_DIR` need not be formed
from `LEP_LABEL`.

After editing file `cpe_26.03_rocm_7.0.sh`, source it:

    source ./cpe_25.09_rocm_6.4.2

to set your programming and runtime environment.

(3) Building LAMMPS

To build LAMMPS run the following command:

    ./configure_build_lammps.sh

If the build is successful, then one will find the LAMMPS binary in
the directory `${LEP_INSTALLATION_DIR}/bin`.

    
## Sample Run Configurations

We have severl run configurations which can be found in directory
`$LEP_TOP_LEVEL/run_configurations/`

We will use run configurations `ar_box_small/1_node_1_gpu` for illustrative purposes.
Change directory to `$LEP_TOP_LEVEL/run_configurations/ar_box_small/1_node_1_gpu`

    cd $LEP_TOP_LEVEL/run_configurations/ar_box_small/1_node_1_gpu

This directory contains 2 files

    ar_box-79.0K.cmd
    ar_box-79.0K.slurm.sh

Modify the file `ar_box-79L.slurm.sh` to use your project ID.

    #SBATCH -A stf006


    #SBATCH -A <to_your_project_id>

