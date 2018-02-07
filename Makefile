# This makefile is used for testing purposes and makes no attempt
# to be portable. Use "luarocks make" to build and install.

CC ?= gcc
CFLAGS = -g -O2
XCFLAGS += -std=c99 -pedantic-errors -fpic
CWARNS = -Wall -Wextra -Wshadow -Wundef -Wconversion -Wc90-c99-compat
LUA = lua
DIST = 0.4 0.3 0.2.1 0.2 0.1.0

all: discount.so

discount.so: discount.o
	$(CC) $(LDFLAGS) -shared -o $@ $^ -lmarkdown

discount.o: discount.c
	$(CC) $(XCFLAGS) $(CPPFLAGS) $(CFLAGS) $(CWARNS) -c -o $@ $<

dist: $(addprefix public/dist/lua-discount-, $(addsuffix .tar.gz, $(DIST)))

public/dist/lua-discount-%.tar.gz: | public/dist/
	git archive --prefix=lua-discount-$*/ -o $@ $*

public/dist/:
	mkdir -p $@

check: all
	$(LUA) test.lua

check-dist: dist
	sha256sum -c .sha256sums.txt

clean:
	rm -f discount.so discount.o


.PHONY: all dist check check-dist clean
.DELETE_ON_ERROR:
