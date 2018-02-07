package = "discount"
version = "scm-1"

description = {
    summary = "Lua bindings for the Discount Markdown library",
    homepage = "https://github.com/craigbarnes/lua-discount",
    license = "ISC"
}

source = {
    url = "git+https://gitlab.com/craigbarnes/lua-discount.git",
    branch = "master"
}

dependencies = {
    "lua >= 5.1"
}

external_dependencies = {
    DISCOUNT = {
        header = "mkdio.h",
        library = "markdown"
    }
}

build = {
    type = "builtin",
    modules = {
        discount = {
            sources = {"discount.c"},
            libraries = {"markdown"}
        }
    }
}
