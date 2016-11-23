include mk/lualib.mk
include mk/discount.mk

CFLAGS      ?= -g -O2 -Wall -Wextra -Wshadow
XCFLAGS     += -fPIC
XCFLAGS     += $(LUA_CFLAGS) $(DISCOUNT_CFLAGS)
XLDFLAGS    += $(DISCOUNT_LDFLAGS)
LUAROCKS    ?= luarocks
HOMEURL      = github.com/craigbarnes/lua-discount
VERSION      = $(or $(shell git describe --abbrev=0),$(error No version info))

all: discount.so

install: all
	$(MKDIR) '$(DESTDIR)$(LUA_CMOD_DIR)/'
	$(INSTALLX) discount.so '$(DESTDIR)$(LUA_CMOD_DIR)/'

uninstall:
	$(RM) '$(DESTDIR)$(LUA_CMOD_DIR)/discount.so'

dist:
	@$(MAKE) --no-print-directory discount-$(VERSION)-1.rockspec

lua-discount-%.tar.gz:
	@git archive --prefix=lua-discount-$*/ -o $@ $*
	@echo 'Generated: $@'

discount-%-1.rockspec: TARBALL = $(word 2, $^)
discount-%-1.rockspec: URL = https://$(HOMEURL)/releases/download/$*/$(TARBALL)
discount-%-1.rockspec: SRCX = md5 = '`md5sum $(TARBALL) | cut -d' ' -f1`'
discount-%-1.rockspec: rockspec.in lua-discount-%.tar.gz | .git/refs/tags/%
	@sed "s|%VERSION%|$*|;s|%URL%|$(URL)|;s|%SRCX%|$(SRCX)|" $< > $@
	@echo 'Generated: $@'

discount-scm-1.rockspec: URL = git://$(HOMEURL)
discount-scm-1.rockspec: SRCX = branch = "master"
discount-scm-1.rockspec: rockspec.in
	@sed 's|%VERSION%|scm|;s|%URL%|$(URL)|;s|%SRCX%|$(SRCX)|' $< > $@
	@echo 'Generated: $@'

check: all test.lua
	@$(LUA) test.lua

check-valgrind:
	@$(MAKE) check LUA='valgrind -q --error-exitcode=1 $(LUA)'

check-rockspec: LUA_PATH = ;;
check-rockspec: dist discount-scm-1.rockspec
	$(LUAROCKS) lint discount-$(VERSION)-1.rockspec
	$(LUAROCKS) lint discount-scm-1.rockspec

clean:
	$(RM) discount.so discount.o lua-discount-*.tar.gz \
	      discount-*.rockspec discount-*.rock


.DEFAULT_GOAL = all
.PHONY: all install uninstall check check-valgrind clean dist
.DELETE_ON_ERROR:
