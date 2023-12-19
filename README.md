lua-discount
============

[Lua] bindings for the [Discount] [Markdown] library.

Status
------

This project is **unmaintained**.

The upstream [Discount] library, which the lua-discount C module depends
upon (and dynamically links against), has broken API/ABI compatability
in release 3.0.0a, with no documentation provided on why this was done
or what downstream changes are required. Resolving this issue in a way
that allows compiling with both the new and old APIs is not something I
have the time or motivation for and since I haven't needed this module
myself for quite a while, I no longer have the inclination to update or
maintain it.

License
-------

ISC [License][] (SPDX: [`ISC`]).


[Lua]: https://www.lua.org/
[Discount]: http://www.pell.portland.or.us/~orc/Code/discount/
[Markdown]: https://en.wikipedia.org/wiki/Markdown
[License]: LICENSE
[`ISC`]: https://spdx.org/licenses/ISC.html
