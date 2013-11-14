lua-discount
============

Lua bindings for the [Discount] [Markdown] library.

Installation
------------

    make
    make check
    [sudo] make install

Usage
-----

The `discount` module provides a single function:

```lua
function discount(input, ...)
```

### Parameters

* `input`: A string of text in [Markdown format]
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

```lua
local discount = require "discount"
local doc = assert(discount("# Hello", "toc", "strict"))
print(doc.body, "\n\n\n", doc.index)
```

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
notables        | Disable [PHP Markdown Extra] style [tables]
nostrikethrough | Disable `~~strikethrough~~`
compat          | Compatability with MarkdownTest_1.0
autolink        | Turn URLs into links, even without enclosing angle brackets
safelink        | Paranoid check for link protocol
noheader        | Disable [Pandoc] style [headers]
tabstop         | Expand tabs to 4 spaces
nodivquote      | Disable `>%class%` blocks
noalphalist     | Disable alphabetic lists
nodlist         | Disable definition lists
extrafootnote   | Enable [PHP Markdown Extra] style [footnotes]
embed           | Equivalent to combining `nolinks`, `noimages` and `tagtext`

[Discount]: http://www.pell.portland.or.us/~orc/Code/discount/
[Markdown]: http://daringfireball.net/projects/markdown
[Markdown format]: http://daringfireball.net/projects/markdown/syntax
[SmartyPants]: http://daringfireball.net/projects/smartypants/
[PHP Markdown Extra]: http://michelf.com/projects/php-markdown/extra/
[tables]: http://michelf.ca/projects/php-markdown/extra/#table
[Pandoc]: http://johnmacfarlane.net/pandoc/
[Pandoc-style header]: http://www.pell.portland.or.us/~orc/Code/discount/#headers
[headers]: http://johnmacfarlane.net/pandoc/README.html#title-block
[pseudo-protocols]: http://www.pell.portland.or.us/~orc/Code/discount/#pseudo
[footnotes]: http://michelf.com/projects/php-markdown/extra/#footnotes
