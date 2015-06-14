#include <fcgi_stdio.h>

#include "lsf.h"

extern void OS_LibShutdown();

int lsf_start(lua_State *L, int accept) {

    while (FCGI_Accept() >= 0) {
        lua_rawgeti(L, LUA_REGISTRYINDEX, accept);
        lua_pcall(L, 0, 1, 0);
        printf(lua_tostring (L, -1));
    }

    FCGI_Finish();

    OS_LibShutdown();

    return 0;
}