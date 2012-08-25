CFLAGS  = -O2 -Wall
LDFLAGS = -shared -fPIC
LIBS    = -lmarkdown

discount.so: ldiscount.o
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS) -o $@ $^

check: discount.so
	@lua -e 'local md = require "discount" print(md "*It works!*")'

clean:
	rm -f discount.so *.o


.PHONY: check clean
