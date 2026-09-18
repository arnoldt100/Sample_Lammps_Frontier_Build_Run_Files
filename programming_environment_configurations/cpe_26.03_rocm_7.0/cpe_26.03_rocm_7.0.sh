#! /usr/bin/env bash

# This file configures the programming environment for the AMD programming
# environment 8.6.0 with rocm 7.0.* Frontier supercomputer.

# ----------------------------------------------------
# Provides a unique label for this build configuration.
#
# For different build configuration, provide a unique label.
# The environmental variable LEP_LABEL is used by other
# scripts to point to the binaries for this build
# lammps configuration.
# ----------------------------------------------------
export LEP_LABEL="cpe_26.03_roc_7.0"

# ----------------------------------------------------
# The absolute path where the lammps binaries and libraries are installed.
#
# Use the environmental label to provide a unique installation directory for
# this build configuration. 
#
# The user should edit this path to suit their needs. 
# ----------------------------------------------------
export LEP_INSTALLATION_DIR="${HOME}/sw/lammps_mixed_precision/${LEP_LABEL}"

# ----------------------------------------------------
# Warning!
#
# The below environmental variables should be sufficient
# to build LAMMPS. Only modify unless neccssary.
#
# ----------------------------------------------------

# ----------------------------------------------------
# Define the ROCm version.
# ----------------------------------------------------
export LEP_ROCM_VERSION="7.0.2"

# ----------------------------------------------------
# Define the path to top level CMakeLists.txt and
# build directory.
# ----------------------------------------------------
export LEP_PATH_TO_LAMMPS_SOURCE="${LEP_LAMMPS_ROOT}"
export LEP_PATH_TO_LAMMPS_BUILD_TREE="${LEP_LAMMPS_ROOT}/${LEP_LABEL}/build"

# ----------------------------------------------------
# Enable GPU MPI aware capability.
# ----------------------------------------------------
export MPICH_GPU_SUPPORT_ENABLED=1

# ----------------------------------------------------
# Define the C++ standard.
# ----------------------------------------------------
export LEP_CXX_STANDARD='20'

# ----------------------------------------------------
# Define the compilers
# ----------------------------------------------------
export LEP_CXX_COMPILER="hipcc"
export LEP_C_COMPILER="hipcc"

# ----------------------------------------------------
# An array of Frontier modules to load to set the
# programming environment.
#
# ----------------------------------------------------
my_programming_environment=("PrgEnv-amd"
  "cpe/26.03"
  "rocm/${LEP_ROCM_VERSION}"
  "craype-accel-amd-gfx90a"
  "cray-fftw/3.3.10.11" )

for tmp_module in "${my_programming_environment[@]}"; do
    module load "${tmp_module}"
done

