/*
 Lua bindings for the Discount Markdown library.
 Copyright (c) 2012-2018 Craig Barnes

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

#include <limits.h>
#include <stddef.h>
#include <lua.h>
#include <lauxlib.h>
#include <mkdio.h>

static const char *const options[] = {
    "nolinks", "noimages", "nopants", "nohtml", "strict",
    "tagtext", "noext", "cdata", "nosuperscript", "norelaxed",
    "notables", "nostrikethrough", "toc", "compat", "autolink",
    "safelink", "noheader", "tabstop", "nodivquote",
    "noalphalist", "nodlist", "extrafootnote", "nostyle",
    "nodldiscount", "dlextra", "fencedcode", "idanchor",
    "githubtags", "urlencodedanchor", "latex", "embed",
    NULL
};

static const unsigned int option_codes[] = {
    MKD_NOLINKS, MKD_NOIMAGE, MKD_NOPANTS, MKD_NOHTML, MKD_STRICT,
    MKD_TAGTEXT, MKD_NO_EXT, MKD_CDATA, MKD_NOSUPERSCRIPT, MKD_NORELAXED,
    MKD_NOTABLES, MKD_NOSTRIKETHROUGH, MKD_TOC, MKD_1_COMPAT, MKD_AUTOLINK,
    MKD_SAFELINK, MKD_NOHEADER, MKD_TABSTOP, MKD_NODIVQUOTE,
    MKD_NOALPHALIST, MKD_NODLIST, MKD_EXTRA_FOOTNOTE, MKD_NOSTYLE,
    MKD_NODLDISCOUNT, MKD_DLEXTRA, MKD_FENCEDCODE, MKD_IDANCHOR,
    MKD_GITHUBTAGS, MKD_URLENCODEDANCHOR, MKD_LATEX, MKD_EMBED
};

static void add_field(lua_State *L, const char *k, const char *v) {
    lua_pushstring(L, v);
    lua_setfield(L, -2, k);
}

static void add_lfield(lua_State *L, const char *k, const char *v, size_t n) {
    lua_pushlstring(L, v, n);
    lua_setfield(L, -2, k);
}

static int compile(lua_State *L) {
    MMIOT *doc;
    unsigned int flags = 0;
    char *body = NULL, *toc = NULL, *css = NULL;
    int body_size, toc_size, css_size, i, argc;

    int input_size;
    size_t lstr_size;
    const char *input = luaL_checklstring(L, 1, &lstr_size);
    luaL_argcheck(L, lstr_size < INT_MAX, 1, "string too long");
    input_size = (int) lstr_size;

    for (i = 2, argc = lua_gettop(L); i <= argc; i++) {
        flags |= option_codes[luaL_checkoption(L, i, NULL, options)];
    }

    doc = mkd_string(input, input_size, flags);
    if (doc == NULL) {
        lua_pushnil(L);
        lua_pushstring(L, "mkd_string() returned NULL");
        return 2;
    }

    if (mkd_compile(doc, flags) != 1) {
        mkd_cleanup(doc);
        lua_pushnil(L);
        lua_pushstring(L, "mkd_compile() failed");
        return 2;
    }

    body_size = mkd_document(doc, &body);
    if (body == NULL || body_size < 0) {
        mkd_cleanup(doc);
        lua_pushnil(L);
        lua_pushstring(L, "mkd_document() failed");
        return 2;
    }

    lua_createtable(L, 0, 4);
    add_lfield(L, "body", body, (size_t) body_size);
    add_field(L, "title", mkd_doc_title(doc));
    add_field(L, "author", mkd_doc_author(doc));
    add_field(L, "date", mkd_doc_date(doc));

    if ((css_size = mkd_css(doc, &css)) > 0 && css) {
        add_lfield(L, "css", css, (size_t) css_size);
    }

    if ((flags & MKD_TOC) && (toc_size = mkd_toc(doc, &toc)) > 0 && toc) {
        add_lfield(L, "index", toc, (size_t) toc_size);
    }

    mkd_cleanup(doc);
    return 1;
}

int luaopen_discount(lua_State *L) {
    lua_createtable(L, 0, 1);
    lua_pushcfunction(L, compile);
    lua_setfield(L, -2, "compile");
    return 1;
}
