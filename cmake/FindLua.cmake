# CMake module to search for Lua headers
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products 
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# If it's found it sets LUA_FOUND to TRUE
# and following variables are set:
#    LUA_INCLUDE_DIR
#    LUA_LIBRARY

# Locate header
FIND_PATH(LUA_INCLUDE_DIR
    NAMES
        lua.h
    PATHS
        /usr/local/include
        /usr/include
        /usr/pkg/include
        $ENV{HOME}/pkg/include
    #MSVC
        "$ENV{LIB_DIR}/include"
        $ENV{INCLUDE}
)

# Locate library
FIND_LIBRARY(LUA_LIBRARY
    NAMES
        lua
        liblua
    PATHS 
        /usr/local/lib
        /usr/lib
        /usr/lib64
        /usr/pkg/lib
        $ENV{HOME}/pkg/lib
    #MSVC
        "$ENV{LIB_DIR}/lib"
        $ENV{LIB}
)

IF (LUA_INCLUDE_DIR AND LUA_LIBRARY)
    SET(LUA_FOUND TRUE)
ELSE (LUA_INCLUDE_DIR AND LUA_LIBRARY)
    SET(LUA_FOUND FALSE)
ENDIF (LUA_INCLUDE_DIR AND LUA_LIBRARY)

IF (LUA_FOUND)
    MESSAGE(STATUS "Found lua.h: ${LUA_INCLUDE_DIR}")
    MESSAGE(STATUS "Found lua: ${LUA_LIBRARY}")
ELSE (LUA_FOUND)
    MESSAGE(FATAL_ERROR "Could not find lua")
ENDIF (LUA_FOUND)
