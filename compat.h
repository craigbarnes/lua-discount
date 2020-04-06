#ifndef LUA_VERSION_NUM
# error Lua >= 5.1 is required.
#endif

#ifdef __has_attribute
# define HAS_ATTRIBUTE(x) __has_attribute(x)
#else
# define HAS_ATTRIBUTE(x) 0
#endif

#ifdef __has_builtin
# define HAS_BUILTIN(x) __has_builtin(x)
#else
# define HAS_BUILTIN(x) 0
#endif

#if defined(__GNUC__) || HAS_ATTRIBUTE(visibility)
# define EXPORT __attribute__((__visibility__("default")))
#elif defined(_WIN32)
# define EXPORT __declspec(dllexport)
#else
# define EXPORT
#endif

#if (defined(__GNUC__) || HAS_BUILTIN(__builtin_expect)) && defined(__OPTIMIZE__)
# define likely(x) __builtin_expect(!!(x), 1)
# define unlikely(x) __builtin_expect(!!(x), 0)
#else
# define likely(x) (x)
# define unlikely(x) (x)
#endif
