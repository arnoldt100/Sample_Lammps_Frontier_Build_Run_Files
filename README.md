# Introduction

This package provides sample build and run files for LAMMPS
on OLCF's Frontier supercomputer.

There are three steps:

1. Satisfying the prerequisites
2. Building LAMMPS
3. Running a sample configuration


## Prerequisites
These examples were tested in a Bash shell. If your preferred
shell is not Bash, you may need to modify some files for your
shell environment. The Bash scripts are simple, so adapting
them should be straightforward.

You will need your project ID to configure the batch files
used to run the sample configurations.

Finally, you will need a LAMMPS source tree. This package builds LAMMPS
using CMake.

(1) The first step is to modify the file `lep.lammps.sh` to point to your LAMMPS
source tree. When sourced, this file sets the following environment variables:

    LEP_TOP_LEVEL
    LEP_LAMMPS_ROOT

The environment variable `LEP_TOP_LEVEL` points to the top-level directory of this
Git repository.

The environment variable `LEP_LAMMPS_ROOT` points to the top-level directory of your
LAMMPS source tree.

To get a LAMMPS package, run the following commands:

    cd ./src
    git clone git@github.com:lammps/lammps.git
    cd ../

Then modify `LEP_LAMMPS_ROOT` in the file `lep.lammps.sh` to point to
`${LEP_TOP_LEVEL}/src/lammps`.
    
    export LEP_LAMMPS_ROOT="${LEP_TOP_LEVEL}/src/lammps"

(2) From the top-level directory of this package, source the file `lep.lammps.sh`:

    source ./lep.lammps.sh

It is important to run the source command from the top-level directory of this package;
otherwise, many scripts will fail. Echoing `${LEP_LAMMPS_ROOT}` should display the path
to the LAMMPS source tree:

    echo ${LEP_LAMMPS_ROOT}

## Building LAMMPS

The directory `${LEP_TOP_LEVEL}/programming_environment_configurations` contains
sample build configurations. We use `cpe_25.09_rocm_6.4.2` as an illustrative case.

(1) Change to directory `cpe_25.09_rocm_6.4.2`:

    cd ${LEP_TOP_LEVEL}/programming_environment_configurations/cpe_25.09_rocm_6.4.2

This directory contains two files:

    cpe_25.09_rocm_6.4.2.sh
    configure_build_lammps.sh

Sourcing the file `cpe_25.09_rocm_6.4.2.sh` sets the programming and runtime environment.
Executing the file `configure_build_lammps.sh` builds the LAMMPS package.

(2) Set up the programming and run environment

Edit the file `configure_build_lammps.sh` by setting the following environment
variables:

    LEP_LABEL
    LEP_INSTALLATION_DIR

The variable `LEP_LABEL` can be set to any string. It is used as a label or tag to
help differentiate build configurations. Note that this variable is used
to form Unix file paths, so use only alphanumeric characters and underscores. This
will ensure that `LEP_LABEL` produces valid Unix file paths.

The variable `LEP_INSTALLATION_DIR` sets the path to where the LAMMPS package
will be installed. No other variables need to be modified for this build
configuration. Note that `LEP_INSTALLATION_DIR` does not need to be formed
from `LEP_LABEL`.

After editing the file `cpe_25.09_rocm_6.4.2.sh`, source it:

    source ./cpe_25.09_rocm_6.4.2.sh

to set your programming and runtime environment.

(3) Building LAMMPS

To build LAMMPS, run the following command:

    ./configure_build_lammps.sh

If the build is successful, the LAMMPS binary will be located in
the directory `${LEP_INSTALLATION_DIR}/bin`.

    
## Sample Run Configurations

Several run configurations are available in the directory
`${LEP_TOP_LEVEL}/run_configurations/`.

We use `ar_box_small/1_node_1_gpu` as an illustrative example. Change to the directory
`${LEP_TOP_LEVEL}/run_configurations/ar_box_small/1_node_1_gpu`:

    cd ${LEP_TOP_LEVEL}/run_configurations/ar_box_small/1_node_1_gpu

This directory contains two files:

    ar_box-79.0K.cmd
    ar_box-79.0K.slurm.sh

Modify the file `ar_box-79.0K.slurm.sh` to use your project ID.

    #SBATCH -A stf006

         to

    #SBATCH -A <to_your_project_id>

From within the directory `${LEP_TOP_LEVEL}/run_configurations/ar_box_small/1_node_1_gpu`,
run the following command:

    sbatch ./ar_box-79.0K.slurm.sh

This submits the job to the Frontier queues. The script does the following:

    (1) Creates a work directory `${MEMBERWORK}/stf006/${parent_work_dir}/${child_work_dir}/run-nm-${run_nm}/${SLURM_JOBID}`.
    (2) Copies all input files to the work directory.
    (3) Runs the simulation.

This generates two files in the work directory:

    (1) A LAMMPS log file `*.log`
    (2) A file named `velocity_seed.txt`

The log file contains information about the simulation.

# Changing the Simulation Runtime

To change the simulation runtime, edit the following line in the LAMMPS
command file `ar_box-79.0K.cmd`:

    variable simulation_time string "0.035" # The simulation time in nanoseconds

The runtime is roughly proportional to the simulation time. In this example,
to approximately double the runtime, change `0.035` to `0.070`.

Be careful to not exceed the SLURM batch wall time. All jobs are currently set for 30 
minutes.
