PREFIX  = /usr/local
LIBDIR  = $(PREFIX)/lib/lua/5.1
CFLAGS  = -O2 -Wall -fPIC
LDFLAGS = -shared
LDLIBS  = -lmarkdown

discount.so: ldiscount.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $<

install: discount.so
	install -Dpm0755 discount.so $(DESTDIR)$(LIBDIR)/discount.so

uninstall:
	rm -f $(DESTDIR)$(LIBDIR)/discount.so

check: discount.so
	@lua -e 'local md = require "discount" print(md "*It works!*")'

clean:
	rm -f discount.so ldiscount.o


.PHONY: install uninstall check clean
