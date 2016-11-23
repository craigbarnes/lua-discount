DISCOUNT_PKG = libmarkdown >= 2.2.1
DISCOUNT_SRCDIR = build/discount-2.2.1

PKGCHECK = $(if \
    $(shell pkg-config --short-errors --modversion '$(DISCOUNT_PKG)'),, \
    $(error pkg-config error) \
)

ifdef USE_LOCAL_DISCOUNT
 DISCOUNT_CFLAGS = -I$(DISCOUNT_SRCDIR)
 discount.so: $(DISCOUNT_SRCDIR)/libmarkdown.a
 discount.o: | $(DISCOUNT_SRCDIR)/libmarkdown.a
else
 DISCOUNT_CFLAGS ?= $(PKGCHECK) $(shell pkg-config --cflags '$(DISCOUNT_PKG)')
 DISCOUNT_LDFLAGS ?= $(PKGCHECK) $(shell pkg-config --libs '$(DISCOUNT_PKG)')
endif

build/discount-%/libmarkdown.a: | build/discount-%/
	cd $| && ./configure.sh
	$(MAKE) -C $| CFLAGS='-O2 -fPIC'

build/discount-%/: | build/discount-%.tar.gz
	cd build && gunzip -d < discount-$*.tar.gz | tar -xf -

build/discount-%.tar.gz: | build/
	curl -sSL -o $@ https://github.com/Orc/discount/archive/v$*.tar.gz

build/:
	mkdir -p $@


.SECONDARY: $(DISCOUNT_SRCDIR)/
