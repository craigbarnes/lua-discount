include mk/lualib.mk
include mk/discount.mk
-include mk/dist.mk

CFLAGS      ?= -g -O2 -Wall -Wextra -Wshadow
XCFLAGS     += -fPIC
XCFLAGS     += $(LUA_CFLAGS) $(DISCOUNT_CFLAGS)
XLDFLAGS    += $(DISCOUNT_LDFLAGS)

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
	$(RM) discount.so discount.o lua-discount-*.tar.gz \
	      discount-*.rockspec discount-*.rock


.DEFAULT_GOAL = all
.PHONY: all install uninstall check check-valgrind clean
.DELETE_ON_ERROR:
