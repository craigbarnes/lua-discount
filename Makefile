VERSION = 0.2
PREFIX  = /usr/local
LIBDIR  = $(PREFIX)/lib/lua/5.1
CFLAGS  = -O2 -Wall -fPIC
LDFLAGS = -shared
LDLIBS  = -lmarkdown

discount.so: discount.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: discount.so
	install -Dpm0755 discount.so $(DESTDIR)$(LIBDIR)/discount.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/discount.so

check: discount.so test.lua
	@lua test.lua && echo 'Tests passed'

clean:
	rm -f discount.so discount.o


.PHONY: install uninstall check clean
