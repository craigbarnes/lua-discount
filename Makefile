VERSION = 0.2
CFLAGS  = -O2 -fPIC -std=c89 -Wall -Wpedantic -Wextra
LDFLAGS = -shared
LDLIBS  = -lmarkdown
LUAVER  = $(shell pkg-config --variable=V lua)
LIBDIR  = $(shell pkg-config --variable=libdir lua)
LUACDIR = $(LIBDIR)/lua/$(LUAVER)
LUA     = lua

all: discount.so

discount.so: discount.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: all
	mkdir -p "$(DESTDIR)$(LUACDIR)/"
	install -p -m0755 discount.so "$(DESTDIR)$(LUACDIR)/discount.so"

uninstall:
	$(RM) -r "$(DESTDIR)$(LUACDIR)/discount.so"

check: all test.lua
	@$(RUNVIA) $(LUA) test.lua

check-valgrind:
	@$(MAKE) check RUNVIA='valgrind -q --leak-check=full --error-exitcode=1'

clean:
	$(RM) discount.so discount.o


ifeq ($(LIBDIR),)
  $(error Couldn't find Lua library path, please specify manually)
endif

ifeq ($(LUAVER),)
  $(error Couldn't find Lua version number, please specify manually)
endif

.PHONY: all install uninstall check check-valgrind clean
