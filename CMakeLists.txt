cmake_minimum_required(VERSION 2.6)

project(lua-simple-fcgi C)

set(CMAKE_BUILD_TYPE Debug)

set(CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake_modules ${CMAKE_MODULE_PATH})

find_package(Lua)

find_package(FCGI)

include_directories(${LUA_INCLUDE_DIR} ${FCGI_INCLUDE_DIR})

add_executable (lua-fcgi main.c)

target_link_libraries(lua-fcgi m ${LUA_LIBRARY} ${FCGI_LIBRARY})
