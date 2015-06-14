cmake_minimum_required(VERSION 2.6)

project(lua-simple-fcgi C)

set(CMAKE_BUILD_TYPE Debug)

find_package(lua)

include_directories(${LUA_INCLUDE_DIR})

add_executable (lua-fcgi main.c lsf.c)

target_link_libraries(lua-fcgi ${LUA_LIBRARY})