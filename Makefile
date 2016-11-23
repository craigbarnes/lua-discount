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

print-lua-v:
	@echo '$(LUA)'
	@$(LUA) -v

check: all test.lua
	@$(LUA) test.lua

check-valgrind:
	@$(MAKE) check LUA='valgrind -q --error-exitcode=1 $(LUA)'

clean: clean-obj
	$(RM) lua-discount-*.tar.gz discount-*.rockspec discount-*.rock

clean-obj:
	$(RM) discount.so discount.o


.DEFAULT_GOAL = all

.PHONY: \
    all install uninstall \
    check check-valgrind print-lua-v \
    clean clean-obj

.DELETE_ON_ERROR:
