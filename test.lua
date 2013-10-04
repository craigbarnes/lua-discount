package.path  = ''
package.cpath = './?.so'
local markdown = require "discount"

assert(markdown "*It works!*" == "<p><em>It works!</em></p>")
