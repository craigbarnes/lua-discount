package.path  = ''
package.cpath = './?.so'
local markdown = require "discount"
local doc, toc

assert(markdown "*It works!*" == "<p><em>It works!</em></p>")

doc, toc = markdown("", "toc")
assert(doc == "" and toc == "")

doc, toc = markdown("")
assert(doc == "" and not toc)
