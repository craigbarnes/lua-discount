VERSION = 0.2
PREFIX  = /usr/local
LUAVER  = 5.2
LIBDIR  = $(PREFIX)/lib/lua/$(LUAVER)
CFLAGS  = -O2 -fPIC -std=c89 -Wall -Wpedantic -Wextra
LDFLAGS = -shared
LDLIBS  = -lmarkdown
LUA     = lua

all: discount.so

discount.so: discount.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: all
	install -Dpm0755 discount.so $(DESTDIR)$(LIBDIR)/discount.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/discount.so

check: all test.lua
	@$(RUNVIA) $(LUA) test.lua

check-valgrind:
	@$(MAKE) check RUNVIA='valgrind -q --leak-check=full --error-exitcode=1'

clean:
	rm -f discount.so discount.o


.PHONY: install uninstall check clean
