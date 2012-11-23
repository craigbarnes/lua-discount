CFLAGS  = -O2 -Wall -fPIC
LDFLAGS = -shared
LDLIBS  = -lmarkdown

discount.so: ldiscount.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $<

check: discount.so
	@lua -e 'local md = require "discount" print(md "*It works!*")'

clean:
	rm -f discount.so ldiscount.o


.PHONY: check clean
