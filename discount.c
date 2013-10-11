/** Lua bindings for the Discount Markdown library.
 * @copyright 2012-2013 Craig Barnes
 * @license ISC
**/

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

static int render(lua_State *L) {
    MMIOT *doc;
    mkd_flag_t flags = 0;
    size_t len;
    const char *str = luaL_checklstring(L, 1, &len);
    int i, n;

    for (i = 2, n = lua_gettop(L); i <= n; i++) {
        int option_index = luaL_checkoption(L, i, NULL, options);
        flags |= option_codes[option_index];
    }

    doc = mkd_string(str, len, flags);
    if (mkd_compile(doc, flags)) {
        char *result, *toc;
        int result_size = 0, toc_size = 0;
        if ((result_size = mkd_document(doc, &result)) != EOF) {
            if (flags & MKD_CDATA) {
                result_size = mkd_xml(result, result_size, &result);
            }
            lua_pushlstring(L, result, result_size);

            toc_size = mkd_toc(doc, &toc);
            lua_pushlstring(L, toc, toc_size);

            mkd_cleanup(doc);
            return 2;
        }
        return 0;
    } else {
        mkd_cleanup(doc);
        return luaL_error(L, "failed to process document");
    }
}

int luaopen_discount(lua_State *L) {
    lua_pushcfunction(L, render);
    return 1;
}
