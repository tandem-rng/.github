cmake_minimum_required(VERSION 3.25)
project(cross_dump_kokkos LANGUAGES CXX)

set(PORT "" CACHE PATH "tandem-kokkos checkout")
set(TANDEM_TESTS OFF)
add_subdirectory(${PORT} port)

add_executable(dump dump.cpp)
target_link_libraries(dump PRIVATE tandem::kokkos)
# The port's tests build the same way: host normals are bit exact only without contraction.
target_compile_options(dump PRIVATE -ffp-contract=off)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64")
    target_compile_options(dump PRIVATE -mfma)
endif()
