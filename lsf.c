#include "lsf.h"
#include <unistd.h>

int lsf_start(lua_State *L, int accept) {

    // call accept
    lua_rawgeti(L, LUA_REGISTRYINDEX, accept);

    lua_pcall(L, 0, 0, 0);

    printf("pid: %d\n", getpid());

    sleep(30);
    sleep(30);

    return 0;
}