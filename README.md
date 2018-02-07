lua-discount
============

Lua bindings for the [Discount] [Markdown] library.

Requirements
------------

* C compiler
* [Lua] `>= 5.1`
* [Discount] `>= 2.2.1`

Installation
------------

    luarocks install discount

Usage
-----

The `discount` module provides a single function:

    discount.compile(input, ...)

### Parameters

* `input`: A string of Markdown text to be parsed
* `...`: zero or more option strings (see below)

### Returns

1. A table, with the following fields:
   * `body`: The Markdown document rendered as HTML.
   * `index`: A HTML table of contents (if the `toc` option was enabled,
     otherwise `nil`).
   * `css`: All `<style>` elements from the document, concatenated
     together, or `nil` if no such elements were found.
   * `title`: The first line from the [Pandoc-style header], or `nil`.
   * `author`: The second line from the Pandoc-style header, or `nil`.
   * `date`: The third line from the Pandoc-style header, or `nil`.

### Returns (on error)

1. `nil`
2. An error message

Example
-------

    local discount = require "discount"
    local doc = assert(discount.compile("# Hello", "toc", "strict"))
    io.write(doc.body, "\n\n\n", doc.index)

Options
-------

Option          | Action
----------------|------------------------------------------
toc             | Enable table of contents
nolinks         | Disable links and disallow `<a>` tags
noimages        | Disable images and disallow `<img>` tags
nopants         | Disable [SmartyPants]
nohtml          | Don't allow raw HTML at all
strict          | Disable superscript and relaxed emphasis
tagtext         | Process text inside html tags
noext           | Disable [pseudo-protocols]
cdata           | Generate code for XML (using `![CDATA[...]]`)
nosuperscript   | Disable superscript (`A^B`)
norelaxed       | Emphasis happens *everywhere*
notables        | Disable [Markdown Extra] style tables
nostrikethrough | Disable `~~strikethrough~~`
compat          | Compatability with MarkdownTest_1.0
autolink        | Turn URLs into links, even without enclosing angle brackets
safelink        | Paranoid check for link protocol
noheader        | Disable [Pandoc] style [headers]
tabstop         | Expand tabs to 4 spaces
nodivquote      | Disable `>%class%` blocks
noalphalist     | Disable alphabetic lists
nodlist         | Disable definition lists
extrafootnote   | Enable [Markdown Extra] style footnotes
nostyle         | Don't extract `<style>` blocks
nodldiscount    | Disable Discount style definition lists
dlextra         | Enable [Markdown Extra] style definition lists
fencedcode      | Enable fenced code blocks
idanchor        | Use `id=` anchors for TOC links
githubtags      | Allow dash and underscore in element names
urlencodedanchor| URL encode non-identifier chars instead of replacing with dots
latex           | Handle embedded LaTeX escapes
embed           | Equivalent to combining `nolinks`, `noimages` and `tagtext`

[License]
---------

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


[License]: http://en.wikipedia.org/wiki/ISC_license "ISC License"
[Discount]: http://www.pell.portland.or.us/~orc/Code/discount/
[Markdown]: https://en.wikipedia.org/wiki/Markdown
[Lua]: https://www.lua.org/
[SmartyPants]: http://www.pell.portland.or.us/~orc/Code/discount/#smartypants
[Markdown Extra]: https://michelf.ca/projects/php-markdown/extra/
[Pandoc]: http://johnmacfarlane.net/pandoc/
[Pandoc-style header]: http://www.pell.portland.or.us/~orc/Code/discount/#headers
[headers]: http://johnmacfarlane.net/pandoc/README.html#title-block
[pseudo-protocols]: http://www.pell.portland.or.us/~orc/Code/discount/#pseudo
