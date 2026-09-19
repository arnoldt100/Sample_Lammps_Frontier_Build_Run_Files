#!/usr/bin/env bash

# Set the number of make parallel threads.
nm_threads=8

# Here we run the cmake command to generate the Makefiles.
cmake \
-D CMAKE_VERBOSE_MAKEFILE:BOOL=ON  \
-D CMAKE_INSTALL_PREFIX=${LEP_INSTALLATION_DIR}  \
-D CMAKE_CXX_COMPILER=${LEP_CXX_COMPILER}  \
-D CMAKE_C_COMPILER=${LEP_C_COMPILER}  \
-D CMAKE_EXE_LINKER_FLAGS="-I${MPICH_DIR}/include -L${MPICH_DIR}/lib -lmpi ${CRAY_XPMEM_POST_LINK_OPTS} -lxpmem ${PE_MPICH_GTL_DIR_amd_gfx90a} ${PE_MPICH_GTL_LIBS_amd_gfx90a}"  \
-D CMAKE_CXX_FLAGS="-fdenormal-fp-math=ieee -fgpu-flush-denormals-to-zero -munsafe-fp-atomics --cuda-gpu-arch=gfx90a --offload-arch=gfx90a -I${MPICH_DIR}/include"  \
-D CMAKE_CXX_STANDARD=${LEP_CXX_STANDARD}  \
-D HIP_ARCH=gfx90a  \
-D HIP_PATH=/opt/rocm-${LEP_ROCM_VERSION}  \
-D PKG_KOKKOS=yes -D Kokkos_ARCH_ZEN3=yes -D Kokkos_ARCH_AMD_GFX90A=yes \
-D Kokkos_ENABLE_HIP=yes -D Kokkos_ENABLE_SERIAL=yes -D Kokkos_ENABLE_HIP_MULTIPLE_KERNEL_INSTANTIATIONS=yes  \
-D FFT_KOKKOS=HIPFFT -D FFT=FFTW3 -D FFTW3_INCLUDE_DIRS=${FFTW_ROOT}/include -D FFTW3_LIBRARIES=${FFTW_ROOT}/lib  \
-D PKG_EXTRA-DUMP=yes -D BUILD_MPI=yes -D PKG_CLASS2=yes -D PKG_DIPOLE=yes -D PKG_RIGID=yes -D PKG_REPLICA=yes \
-D PKG_MANYBODY=yes -D PKG_MOLECULE=yes -D PKG_OPT=yes -D PKG_KSPACE=yes  \
-B ${LEP_PATH_TO_LAMMPS_BUILD_TREE} \
-S ${LEP_PATH_TO_LAMMPS_SOURCE}/cmake

# Here we build and install the lammps binaries.
cd ${LEP_PATH_TO_LAMMPS_BUILD_TREE}
cmake --build ./ -j ${nm_threads}
cmake --install ./ 

# Here we record the lammps git commit and Frontier programming enviroment
git log -1 > ${LEP_INSTALLATION_DIR}/lammps_git_commit.txt
module list 2> ${LEP_INSTALLATION_DIR}/lammps_modulefiles.txt
