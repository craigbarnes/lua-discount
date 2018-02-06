package.path  = ''
package.cpath = './?.so'
local discount = require "discount"
local compile = assert(discount.compile)

do
    local doc = assert(compile "%Title ::\n%Author ::\n%Date ::\n*Text*\n")
    assert(doc.title == "Title ::")
    assert(doc.author == "Author ::")
    assert(doc.date == "Date ::")
    assert(doc.body == "<p><em>Text</em></p>")
end

do
    local doc = assert(compile "<style>a {color: red}</style>Text")
    assert(doc.css == "<style>a {color: red}</style>\n")
end

do
    local doc = assert(compile("", "toc"))
    assert(doc.body == "")
    assert(not doc.index)
end

do
    local doc = assert(compile("# Heading", "toc"))
    assert(doc.body)
    assert(doc.index)
end

io.stderr:write("\27[1;32mAll tests passed\27[0m\n")
