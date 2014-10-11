include lualib.mk

DSC_LDLIBS  ?= -lmarkdown
CFLAGS      ?= -g -O2 -std=c89 -pedantic -Wall -Wextra -Wshadow
XCFLAGS     += -fPIC
XCFLAGS     += $(LUA_CFLAGS) $(DSC_CFLAGS)
XLDFLAGS    += $(DSC_LDFLAGS) $(DSC_LDLIBS)

all: discount.so

install: all
	$(MKDIR) '$(DESTDIR)$(LUA_CMOD_DIR)/'
	$(INSTALLX) discount.so '$(DESTDIR)$(LUA_CMOD_DIR)/'

uninstall:
	$(RM) '$(DESTDIR)$(LUA_CMOD_DIR)/discount.so'

check: all test.lua
	@$(LUA) test.lua

check-valgrind:
	@$(MAKE) check LUA='valgrind -q --error-exitcode=1 $(LUA)'

clean:
	$(RM) discount.so discount.o


.PHONY: all install uninstall check check-valgrind clean
