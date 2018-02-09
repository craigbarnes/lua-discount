#ifndef LUA_VERSION_NUM
# error Lua >= 5.1 is required.
#endif

#ifdef _WIN32
# define EXPORT __declspec(dllexport)
#else
# define EXPORT
#endif
