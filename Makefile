VERSION = 0.2
PREFIX  = /usr/local
LUAVER  = 5.2
LIBDIR  = $(PREFIX)/lib/lua/$(LUAVER)
CFLAGS  = -O2 -std=c89 -Wall -Wpedantic -Wextra
LDFLAGS = -shared
LDLIBS  = -lmarkdown

discount.so: discount.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: discount.so
	install -Dpm0755 discount.so $(DESTDIR)$(LIBDIR)/discount.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/discount.so

check: discount.so test.lua
	@lua test.lua

clean:
	rm -f discount.so discount.o


.PHONY: install uninstall check clean
