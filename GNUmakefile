include mk/compat.mk
include mk/lualib.mk
include mk/discount.mk
include mk/check.mk
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

clean: clean-obj
	$(RM) -r build/ public/
	$(RM) discount-*.rockspec discount-*.rock

clean-obj:
	$(RM) discount.so discount.o


.DEFAULT_GOAL = all
.PHONY: all install uninstall clean clean-obj
.DELETE_ON_ERROR:
