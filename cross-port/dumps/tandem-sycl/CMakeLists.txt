cmake_minimum_required(VERSION 3.25)
project(cross_dump_sycl LANGUAGES CXX)

set(PORT "" CACHE PATH "tandem-sycl checkout")
set(TANDEM_TESTS OFF)
add_subdirectory(${PORT} port)

add_executable(dump dump.cpp)
target_link_libraries(dump PRIVATE tandem::sycl)
tandem_add_sycl(dump)
