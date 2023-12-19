# This makefile is used for testing purposes and makes no attempt
# to be portable. Use "luarocks make" to build and install.

CC ?= gcc
CFLAGS = -g -O2
XCFLAGS += -std=c99 -pedantic-errors -fpic
CWARNS = -Wall -Wextra -Wshadow -Wundef -Wconversion -Wc90-c99-compat
LUA = lua

default:
	@echo 'The Makefile is for development only.' >&2
	@echo 'Use "luarocks make" to install.' >&2

all: discount.so

discount.so: discount.o
	$(CC) $(LDFLAGS) -shared -o $@ $^ -lmarkdown

discount.o: discount.c
	$(CC) $(XCFLAGS) $(CPPFLAGS) $(CFLAGS) $(CWARNS) -c -o $@ $<

check: all
	$(LUA) test.lua

clean:
	rm -f discount.so discount.o


.PHONY: default all check clean
.DELETE_ON_ERROR:
