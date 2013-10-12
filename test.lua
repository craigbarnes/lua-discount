package.path  = ''
package.cpath = './?.so'
local markdown = require "discount"
local doc

doc = markdown [[
% Title ::
% Author ::
% Date ::
*Text*
]]
assert(doc.title == "Title ::")
assert(doc.author == "Author ::")
assert(doc.date == "Date ::")
assert(doc.body == "<p><em>Text</em></p>")

doc = markdown "<style>a {color: red}</style>Text"
assert(doc.css == "<style>a {color: red}</style>\n")

doc = markdown("", "toc")
assert(doc.body == "")
assert(not doc.index)

doc = markdown("# Heading", "toc")
assert(doc.body)
assert(doc.index)

print "All tests passed"
