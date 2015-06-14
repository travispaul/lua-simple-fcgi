#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#include "lsf.h"

lua_State *L;

int lsf_accept;
int lsf_stop;
int lsf_restart;

static void
usage() {
    fprintf(stderr, "Usage:\n  lua-fcgi app.lua\n");
    exit(1);
}

static void
handle_restart(int signo) {

    lua_rawgeti(L, LUA_REGISTRYINDEX, lsf_restart);

    lua_pcall(L, 0, 0, 0);

}

static void
handle_stop(int signo) {

    // XXX
    // We should exit based on a return value
    // and also cleanup lua and fastcgi start

    lua_rawgeti(L, LUA_REGISTRYINDEX, lsf_stop);

    lua_pcall(L, 0, 0, 0);

    exit(0); 

}

int
main(int argc, char *argv[]) {

    if (argc <= 1) {
        usage();
    }

    L = luaL_newstate();

    lsf_accept = 0;
    lsf_stop = 0;
    lsf_restart = 0;

    if (L == NULL) {
        fprintf(stderr, "Failed to create lua state\n");
        return 2;
    }

    luaL_openlibs(L);

    if (luaL_dofile(L, argv[1])) {
        fprintf(stderr, "Error loading lua file: %s\n", argv[1]);
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        return 3;
    }

    if (lua_type(L, -1) != LUA_TTABLE) {
        fprintf(stderr, "Lua file does not return a table.\n");
        return 4;
    }

    // Check that the "accept" function exists and save a reference
    lua_pushstring(L, "accept");

    lua_gettable(L, -2);

    if (lua_isfunction(L, -1)) {
        lua_pushvalue(L, -1);
        lsf_accept = luaL_ref(L, LUA_REGISTRYINDEX);
        lua_pop(L, 1);
    } else {
        fprintf(stderr, "Lua file doesn't provide an \"accept\" function.\n");
        return 5;
    }

    // Save a reference to the "stop" function if it exists
    lua_pushstring(L, "stop");

    lua_gettable(L, -2);

    if (lua_isfunction(L, -1)) {
        lua_pushvalue(L, -1);
        lsf_stop = luaL_ref(L, LUA_REGISTRYINDEX);
        if (signal(SIGTERM, handle_stop) == SIG_ERR) {
            fprintf(stderr, "Unable to set signal handler.\n");
            return 6;
        }
    }

    lua_pop(L, 1);

    // Save a reference to the "restart" function if it exists
    lua_pushstring(L, "restart");

    lua_gettable(L, -2);

    if (lua_isfunction(L, -1)) {
        lua_pushvalue(L, -1);
        lsf_restart = luaL_ref(L, LUA_REGISTRYINDEX);
        if (signal(SIGHUP, handle_restart) == SIG_ERR) {
            fprintf(stderr, "Unable to set signal handler.\n");
            return 7;
        }
    }

    lua_pop(L, 1);

    // Call start function if present
    lua_pushstring(L, "start");

    lua_gettable(L, -2);

    if (lua_isfunction(L, -1)) {
        /// XXX Need to check return value
        if (lua_pcall(L, 0, 0, 0) != 0) {
            fprintf(stderr, "Error calling start function: %s\n",
                lua_tostring(L, -1));
            return 8;
        }
    }

    lua_pop(L, 1);
    

    // This code is kept in a separate header and c file so that we can
    // display the usage if a script is not provided or if the correct
    // entry points are not provided by the script.

    // If the necessary FastCGI headers were included here
    // they would take over stdout and stderr and we couldn't easily
    // send any output to the console until we called FCGI_Accept.

    return lsf_start(L, lsf_accept);
}


