#!/usr/bin/env bash

#SBATCH -A stf006
#SBATCH -J pc-2-node-0_ar_small_box-solid_liquid-double_precision-79.0K-79.0K
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 0:30:00
#SBATCH -N 2
#SBATCH -p batch
#SBATCH -q debug

echo "Node list: $SLURM_JOB_NODELIST"

# ----------------------------------------------------
# Declare the top level batch launch directory.
#
# This  directory contains the LAMMPS input files and slurm batch file. The
# slurm sbatch command is executed form this directory.
# ----------------------------------------------------
declare -r batch_launch_directory="${SLURM_SUBMIT_DIR}"

# ----------------------------------------------------
# The temperature, run number, label and initial
# configuration for this script.
# ----------------------------------------------------
declare -r rcut="28.0"
declare -r temp="79.0"
declare -r intitial_temperature="79.0"
declare -r final_temperature="79.0"
declare -r trial_pdamp="500"
declare -r exp_nm="2-node"
declare -r run_nm="0"
declare -r prec="double_precision"
declare -r box_size="ar_small_box"
declare -r parent_work_dir="ar_box_small_for_wael"
declare -r child_work_dir="PC-${exp_nm}-${box_size}-solid_liquid-${prec}-${initial_temperature}K-${final_temperature}K"
declare -r label="PC-${exp_nm}-${run_nm}-${box_size}-solid_liquid-${prec}-${initial_temperature}K-${final_temperature}K"
declare -r initial_configuration="IC-1-ar_solid_liquid-double_precision-pdamp_500-rcut_28.0-75.0K.production.200000.restart"

# ----------------------------------------------------
# The name of this file.
# ----------------------------------------------------
declare -r my_submit_script="ar_box-${temp}K.slurm.sh"

# -----------------
# No changes should be needed below this comment.
# -----------------

# -----------------
# If set, causes rank 0 to display all MPICH environment variables and their
# current settings at MPI initialization time.
# -----------------
export MPICH_ENV_DISPLAY=1

# ----------------------------------------------------
# The OMP_DISPLAY_ENV environment variable instructs the runtime to display the
# OpenMP version number
# ----------------------------------------------------
export OMP_DISPLAY_ENV=true

# ----------------------------------------------------
# OMP_PROC_BIND:
#   "
#   spread" : The OpenMP threads are pinned to cores that are distant
#              from the parent thread. OMP_PROC_BIND=spread is useful to avoid contention on
#              hardware resources. For example, if threads are working on large amounts of
#              private data then there might be an advantage to using spread to reduce
#              contention on a shared level of cache or memory bandwidth.
# ----------------------------------------------------
export OMP_PROC_BIND='spread'

# ----------------------------------------------------
# OMP_PLACES:
#   threads : Each place corresponds to a single hardware thread on the
#             target machine.
# ----------------------------------------------------
export OMP_PLACES='threads'

# ----------------------------------------------------
# Set the path to the LAMMPS binary, and declare the
# LAMMPS log file.
#
# ----------------------------------------------------
declare -r BIN="${LEP_INSTALLATION_DIR}/bin/lmp"

# ----------------------------------------------------
# Declare the work and result directory.
#
# The "workdir" directory is where the executable is ran.
#
# The "resultdir"" directory is where the resulting output files
# of running the  executable are copied to.
#
# ----------------------------------------------------
declare -r workdir="${MEMBERWORK}/stf006/${parent_work_dir}/${child_work_dir}/run-nm-${run_nm}/${SLURM_JOBID}"

# ----------------------------------------------------
# Declare the LAMMPS command file, log file name.
#
# ----------------------------------------------------
declare -r lammps_log_file="${label}.log"
declare -r command_file="ar_box-${temp}K.cmd"

# ----------------------------------------------------
# Set the job run configuration.
#
# ----------------------------------------------------
declare -r number_nodes=2
declare -r number_tasks_per_node=8
declare -r number_tasks=$((number_nodes * number_tasks_per_node))
declare -r number_logical_cpus_per_task=1
declare -r number_cpus_per_task=1
declare -r number_gpus_per_task=1
declare -r number_gpus_per_node=$((number_tasks_per_node * number_gpus_per_task))
declare -r number_hardware_threads_per_core=1

if [ -d ${workdir} ]; then
  rm -rf "${workdir}"
fi
mkdir -p ${workdir}

cd ${batch_launch_directory}

cp "${batch_launch_directory}/${my_submit_script}" "${workdir}"
cp "${batch_launch_directory}/${command_file}" "${workdir}"
cp "${batch_launch_directory}/../${initial_configuration}" "${workdir}"

cd ${workdir}

srun --nodes "${number_nodes}" \
  --ntasks-per-node "${number_tasks_per_node}" \
  --gpus-per-node ${number_gpus_per_node} \
  --cpus-per-task "${number_cpus_per_task}" \
  --threads-per-core="${number_hardware_threads_per_core}" \
  --cpu-bind=threads \
  -m block:cyclic \
  "${BIN}" -l ${lammps_log_file} -kokkos on g 8 -sf kk -in "${command_file}"

cd ${batch_launch_directory}
