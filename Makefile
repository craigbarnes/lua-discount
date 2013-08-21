VERSION = 0.2
PREFIX  = /usr/local
LIBDIR  = $(PREFIX)/lib/lua/5.1
CFLAGS  = -O2 -Wall -fPIC
LDFLAGS = -shared
LDLIBS  = -lmarkdown

ldiscount.so: ldiscount.o
	$(CC) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: ldiscount.so
	install -Dpm0755 ldiscount.so $(DESTDIR)$(LIBDIR)/ldiscount.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/ldiscount.so

check: ldiscount.so test.lua
	@lua test.lua && echo 'Tests passed'

clean:
	rm -f ldiscount.so ldiscount.o


.PHONY: install uninstall check clean
