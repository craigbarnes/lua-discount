lua-discount
============

Lua binding to [Discount] -- a fast C implementation of the [Markdown] language

Usage
-----

The `discount` module provides a single function, which takes a string of
Markdown formatted text and a list of options.

    local discount = require "discount"
    local html = discount("This is **Markdown**", "noimages", "toc")
    print(html)

Options
-------

* `"nolinks"`  -- Disallow HTML `<a>` tags and Markdown links
* `"noimages"` -- Disallow HTML `<img>` tags and Markdown images
* `"nopants"`  -- Disable [SmartyPants]
* `"nohtml"`   -- Disallow embedded HTML by replacing all `<` with `&lt;`
* `"strict"`   -- Disable relaxed emphasis and superscripts
* `"tagtext"`  -- Don't expand `*` or `_` when used for emphasis
* `"noext"`    -- Disable [pseudo-protocols]
* `"cdata"`    -- Generate output suitable for use as data in an XML document
* `"toc"`      -- Add named anchors for each heading
* `"embed"`    -- Equivalent to `"nolinks"`, `"noimages"` and `"tagtext"`


[Discount]: http://www.pell.portland.or.us/~orc/Code/discount/
[Markdown]: http://daringfireball.net/projects/markdown)
[SmartyPants]: http://daringfireball.net/projects/smartypants/
[pseudo-protocols]: http://www.pell.portland.or.us/~orc/Code/discount/#pseudo
