/** Lua bindings for the Discount Markdown library.
    @copyright 2012-2013 Craig Barnes
    @license ISC
*/

#include <stddef.h>
#include <lua.h>
#include <lauxlib.h>
#include <mkdio.h>

static const char *const options[] = {
    "nolinks", "noimages", "nopants", "nohtml", "strict",
    "tagtext", "noext", "cdata", "nosuperscript", "norelaxed",
    "notables", "nostrikethrough", "toc", "compat", "autolink",
    "safelink", "noheader", "tabstop", "nodivquote",
    "noalphalist", "nodlist", "extrafootnote", "embed", NULL
};

static const int option_codes[] = {
    MKD_NOLINKS, MKD_NOIMAGE, MKD_NOPANTS, MKD_NOHTML, MKD_STRICT,
    MKD_TAGTEXT, MKD_NO_EXT, MKD_CDATA, MKD_NOSUPERSCRIPT, MKD_NORELAXED,
    MKD_NOTABLES, MKD_NOSTRIKETHROUGH, MKD_TOC, MKD_1_COMPAT, MKD_AUTOLINK,
    MKD_SAFELINK, MKD_NOHEADER, MKD_TABSTOP, MKD_NODIVQUOTE,
    MKD_NOALPHALIST, MKD_NODLIST, MKD_EXTRA_FOOTNOTE, MKD_EMBED
};

static int error(lua_State *L, MMIOT *mm, const char *message) {
    if (mm) mkd_cleanup(mm);
    lua_pushnil(L);
    lua_pushstring(L, message);
    return 2;
}

static int render(lua_State *L) {
    mkd_flag_t flags = 0;
    MMIOT *mm = NULL;
    char *doc = NULL;
    char *toc = NULL;
    size_t doc_size = 0, toc_size = 0, input_size = 0;
    const char *input = luaL_checklstring(L, 1, &input_size);
    int top = lua_gettop(L);
    int i = 2;

    for (; i <= top; i++)
        flags |= option_codes[luaL_checkoption(L, i, NULL, options)];

    if ((mm = mkd_string(input, input_size, flags)) == NULL)
        return error(L, mm, "Unable to allocate structure");

    if (mkd_compile(mm, flags) != 1)
        return error(L, mm, "Failed to compile");

    doc_size = mkd_document(mm, &doc);
    if (doc)
        lua_pushlstring(L, doc, doc_size);
    else
        return error(L, mm, "NULL document");

    if (flags & MKD_TOC) {
        toc_size = mkd_toc(mm, &toc);
        if (toc)
            lua_pushlstring(L, toc, toc_size);
        else
            lua_pushliteral(L, "");
    } else
        lua_pushnil(L);

    mkd_cleanup(mm);
    return 2;
}

int luaopen_discount(lua_State *L) {
    lua_pushcfunction(L, render);
    return 1;
}
