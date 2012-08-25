lua-discount
============

Lua binding to [Discount] -- a fast C implementation of the [Markdown] language

Usage
-----

The `discount` module provides a single function, which takes a string of
Markdown formatted text and various, optional configuration flags.

    local discount = require "discount"
    local html = discount("This is **Markdown**", "noimages", "toc")
    print(html)

Options
-------

Option          | Action
----------------|------------------------------------------
nolinks         | Don't do link processing and disallow `<a>` tags
noimage         | Don't do image processing and disallow `<img>` tags
nopants         | Don't use [SmartyPants] (`smartypants()`)
nohtml          | Don't allow raw HTML at all
strict          | Disable `SUPERSCRIPT`, `RELAXED_EMPHASIS`
tagtext         | Process text inside an html tag; no `<em>`, no `<bold>`, no html or `[]` expansion
noext           | Don't allow [pseudo-protocols]
cdata           | Generate code for XML (using `![CDATA[...]]`)
nosuperscript   | Disable superscript (`A^B`)
norelaxed       | Emphasis happens _everywhere_
notables        | Don't process [PHP Markdown Extra] tables.
nostrikethrough | Forbid `~~strikethrough~~`
toc             | Do table of contents processing
compat          | Compatability with MarkdownTest_1.0
autolink        | Make `http://example.com` a link even without `<>`s
safelink        | Paranoid check for link protocol
noheader        | Don't process document headers
tabstop         | Expand tabs to 4 spaces
nodivquote      | Forbid `>%class%` blocks
noalphalist     | Forbid alphabetic lists
nodlist         | Forbid definition lists
extrafootnote   | Enable [PHP Markdown Extra] style [footnotes].


[Discount]: http://www.pell.portland.or.us/~orc/Code/discount/
[Markdown]: http://daringfireball.net/projects/markdown)
[SmartyPants]: http://daringfireball.net/projects/smartypants/
[PHP Markdown Extra]: http://michelf.com/projects/php-markdown/extra/
[pseudo-protocols]: http://www.pell.portland.or.us/~orc/Code/discount/#pseudo
[footnotes]: http://michelf.com/projects/php-markdown/extra/#footnotes
