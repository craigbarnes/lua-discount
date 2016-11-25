LUAROCKS ?= luarocks
PRINTVAR = printf '\033[1m%-17s\033[0m= %s\n' '$(1)' '$(strip $($(1)))'

USERVARS = \
    CFLAGS LIBFLAGS DISCOUNT_CFLAGS DISCOUNT_LDFLAGS \
    LUA_PC LUA_CFLAGS LUA_LMOD_DIR LUA_CMOD_DIR LUA

check: all
	@$(LUA) $(LUAFLAGS) test.lua

check-valgrind:
	@$(MAKE) check LUA='valgrind -q --error-exitcode=1 $(LUA)'

check-dist: dist
	sha1sum -c .dist.sha1sums

check-luarocks-build check-luarocks-make: \
check-luarocks-%: | discount-scm-1.rockspec
	$(LUAROCKS) --tree='$(CURDIR)/build/$@' $* $|
	$(RM) -r build/$@/

check-all:
	$(MAKE) -s clean-obj all print-vars check
	$(MAKE) -s clean-obj all print-vars check LUA_PC=lua53
	$(MAKE) -s clean-obj all print-vars check LUA_PC=lua52
	$(MAKE) -s clean-obj all print-vars check LUA_PC=lua51
	$(MAKE) -s clean-obj all print-vars check LUA_PC=luajit

print-vars:
	@$(foreach VAR, $(USERVARS), $(call PRINTVAR,$(VAR));)
	@$(LUA) -v


.PHONY: \
    check check-valgrind check-all print-vars \
    check-dist check-luarocks-make check-luarocks-build
