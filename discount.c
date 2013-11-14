/*
 Lua bindings for the Discount Markdown library.
 Copyright (c) 2012-2013 Craig Barnes

 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
 copyright notice and this permission notice appear in all copies.

 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
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

static int push_error(lua_State *L, MMIOT *mm, const char *message) {
    if (mm) mkd_cleanup(mm);
    lua_pushnil(L);
    lua_pushstring(L, message);
    return 2;
}

static void add_field(lua_State *L, const char *k, const char *v) {
    lua_pushstring(L, v);
    lua_setfield(L, -2, k);
}

static void add_lfield(lua_State *L, const char *k, const char *v, size_t n) {
    lua_pushlstring(L, v, n);
    lua_setfield(L, -2, k);
}

static int compile(lua_State *L) {
    mkd_flag_t flags = 0;
    MMIOT *mm = NULL;
    char *doc = NULL, *toc = NULL, *css = NULL;
    size_t doc_size = 0, toc_size = 0, css_size = 0, input_size = 0;
    const char *input = luaL_checklstring(L, 1, &input_size);
    const int argc = lua_gettop(L);
    int i = 2;

    for (; i <= argc; i++)
        flags |= option_codes[luaL_checkoption(L, i, NULL, options)];

    if ((mm = mkd_string(input, input_size, flags)) == NULL)
        return push_error(L, mm, "Unable to allocate structure");

    if (mkd_compile(mm, flags) != 1)
        return push_error(L, mm, "Failed to compile");

    doc_size = mkd_document(mm, &doc);
    if (!doc)
        return push_error(L, mm, "NULL document");

    lua_createtable(L, 0, 6);
    add_lfield(L, "body", doc, doc_size);
    add_field(L, "title", mkd_doc_title(mm));
    add_field(L, "author", mkd_doc_author(mm));
    add_field(L, "date", mkd_doc_date(mm));

    if ((css_size = mkd_css(mm, &css)) > 0 && css)
        add_lfield(L, "css", css, css_size);

    if ((flags & MKD_TOC) && (toc_size = mkd_toc(mm, &toc)) > 0 && toc)
        add_lfield(L, "index", toc, toc_size);

    mkd_cleanup(mm);
    return 1;
}

int luaopen_discount(lua_State *L) {
    lua_pushcfunction(L, compile);
    return 1;
}
