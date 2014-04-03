include findlua.mk

VERSION = 0.2
CFLAGS  = -O2 -fPIC -std=c89 -Wall -Wpedantic -Wextra
CFLAGS += $(LUA_CFLAGS)
LDLIBS  = -lmarkdown
LUA     = lua

all: discount.so

install: all
	mkdir -p "$(DESTDIR)$(LUA_CMOD_DIR)/"
	install -p -m0755 discount.so "$(DESTDIR)$(LUA_CMOD_DIR)/discount.so"

uninstall:
	$(RM) "$(DESTDIR)$(LUA_CMOD_DIR)/discount.so"

check: all test.lua
	@$(RUNVIA) $(LUA) test.lua

check-valgrind:
	@$(MAKE) check RUNVIA='valgrind -q --leak-check=full --error-exitcode=1'

clean:
	$(RM) discount.so discount.o discount.lo discount.la
	$(RM) -r .libs/


.PHONY: all install uninstall check check-valgrind clean
