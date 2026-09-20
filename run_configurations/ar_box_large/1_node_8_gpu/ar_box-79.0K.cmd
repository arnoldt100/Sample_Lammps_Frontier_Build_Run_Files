# -----------------
# Simulation command file Argon box production runs 
# at 1 atm and 79.0K.
# -----------------

# -----------------
# Some conversion factors.
# -----------------
variable c_nano_femto string 1000000 # The conversion factor to convert nano to femto.
variable c_pico_femto string 1000 # The conversion factor to convert pico to femto.

# -----------------
# The simulation run number.
# -----------------
variable exp_nm string "1-node-8-gpu"
variable run_nm string "0"

# -----------------
# The simulation precision and box size
# -----------------
variable prec string "double_precision"
variable box_size string "ar_large_box"

# ----------
# The pdamp and tdamp settings.
# ----------
variable npt_tdamp string "100"
variable npt_pdamp string "500"

# -----------------
# If this a continuation of a run, then
# be sure to set simulation_continuation to 1.0.
# 
# If this is a not a continuation, and we are using the restart/data file soley for an
# initial configuration, then set simulation_continuation to 0.0
# -----------------
variable simulation_continuation string "0.0"

# -----------------
# The simulation time step, pressure, and temperature.
# -----------------
variable timestep string "0.5" # The size of the timestep in femtoseconds
variable initial_pressure string "1.0" # The pressure in atm.
variable final_pressure string "1.0" # The pressure in atm.
variable label_final_temperature string "79.0" # The temperature in Kelvin
variable initial_temperature string "79.0" # The temperature in Kelvin
variable final_temperature string "79.0" # The temperature in Kelvin

# -----------------
# The global cutoff for pair_style lj/cut
# -----------------
variable cutoff string "28.0"

# -----------------
# Seting the velocity random seed.
# -----------------
shell "date +%s > velocity_seed.txt"
variable seed file velocity_seed.txt
variable velocity_random_seed equal floor(random(1,1000,${seed}%65534))

# -----------------
# Settings for a graceful shutdown of simulation.
# -----------------
variable my_timeout_time string "23:45:00" # In hrs:min:secs
variable my_timeout_check string "10.0" # In simulation picoseconds

# -----------------
# The simulation time for the run during the npt production runs.
#
# The simulation time for  0.5 fs/step
# -----------------
variable simulation_time string "0.07" # The simulation time in nanoseconds
variable nm_steps equal round(${simulation_time}*${c_nano_femto}/${timestep})

# -----------------
# The simulation label and restart file.
# -----------------
variable label string "PC-${exp_nm}-${run_nm}-${box_size}-solid_liquid-${prec}-${initial_temperature}K-${final_temperature}K"
variable initial_configuration string "IC-1-0-ar_large_box-solid_liquid-double_precision-75.0K-75.0K.production.100000.restart"

# -----------------
# Various data dump settings.
# -----------------
variable thermo_dump_period string "10.0" # In picoseconds (i.e dump every 10 picoseconds)

# -----------------
# Kokkos package options
# -----------------
package kokkos gpu/aware on comm device newton off neigh full neigh/thread on neigh/transpose off 

# -----------------
# Read the intial configuration 
# -----------------
read_restart ${initial_configuration}

# -----------------
# No changes should be needed below this comment.
# -----------------

# -----------------
# Logic for resetting timestep counter.
# -----------------
if "${simulation_continuation}" then &
    "print 'This is a simulation continuation.'" &
else &
    "print 'This is a new simulation.'" &
    "reset_timestep 0"

# -----------------
# Set the charge and mass of the Argon atom.
# -----------------
mass 1 39.948  # Atomic mass of Argon (Ar)

# -----------------
# Set the molecular dynamics timestep.
# -----------------
timestep ${timestep}

# ----------------------
# Force field settings.
# The force field parameters are from the following source:
#   Argon force field revisited: a molecular dynamic study
#   Journal of Physics Communications
#   José Guillermo Méndez-Bermúdez et al 2022 J. Phys. Commun. 6 041002
# See Table 2 for the Wh[2] force field.
# In the paper the reparameterized force field for Wh[2] is epsilon is
# 0.94639 KJ/mol and sigma is 0.33713 nm.
# 
# For the units real, distance is in angstroms and energy is in Kcal/mol. 
# We need to convert nm to angstroms and KJ/mol to Kcal/mol to use Wh[2]
# force field in this LAMMPS command file.
# ----------------------
pair_style lj/cut/kk ${cutoff}
pair_coeff 1 1 0.22619 3.3713
pair_modify tail yes

# ----------------------
# Production Equilibration runs
# ----------------------
variable timeout_check equal round(${my_timeout_check}*${c_pico_femto}/dt)
timer normal timeout ${my_timeout_time} every ${timeout_check}

# ----------------------
# Define the restart dump frequency.
# ----------------------

# ----------------------
# The thermo configuration
# ----------------------
thermo_style custom step time temp econserve etotal ke pe evdwl press
variable thermo_dump_frequency equal round(${thermo_dump_period}*${c_pico_femto}/dt)
thermo ${thermo_dump_frequency}
thermo_modify flush yes

# ----------------------
# Compute the average pressure and dump to a data file.
# ----------------------

# ----------------------
# Compute the average energy and dump to a file.
# ----------------------
variable my_etotal equal etotal
variable my_econserve equal econserve

# ----------------------
# Apply thermostats/barostats to regions. Apply npt thermostat to all.
# ----------------------

# tdamp for the thermostat.
# tdamp is expressed in time units.
variable tdamp equal (${npt_tdamp}*dt)

# pdamp for the barostat.
# pdamp is expressed in time units.
variable pdamp equal (${npt_pdamp}*dt)
fix npt_fix all npt temp ${initial_temperature} ${final_temperature} ${tdamp} aniso ${final_pressure} ${final_pressure} ${pdamp}

# ----------------------
# Constrain the center of mass to the initial value at the beginning of run.
# ----------------------
fix c_o_m all recenter INIT INIT INIT 

# ----------------------
# Constrain the angular and linear system momemtum to 0.
# ----------------------
fix momentum_all all momentum/kk 1 linear 1 1 1 angular

# ----------------------
# Reset velocities 
# ----------------------
velocity all create ${final_temperature} ${velocity_random_seed} sum no dist gaussian

# ----------------------
# Neighbor list settings
# ----------------------
neighbor 2.00 bin
neigh_modify every 5 delay 10 check no
neigh_modify binsize 5.0

run 0

# ----------------------
# Do equilibration and production runs.
# ----------------------
run_style verlet
run ${nm_steps} upto
