LUAROCKS ?= luarocks

HOMEURL = https://craigbarnes.gitlab.io/lua-discount
GITURL  = git+https://gitlab.com/craigbarnes/lua-discount.git
TAGS    = 0.0.1 0.0.2 0.1.0 0.2

dist: $(addprefix public/dist/lua-discount-, $(addsuffix .tar.gz, $(TAGS)))

public/dist/lua-discount-%.tar.gz: | public/dist/
	git archive --prefix=lua-discount-$*/ -o $@ $*

discount-%-1.rockspec: URL = $(HOMEURL)/dist/lua-discount-$*.tar.gz
discount-%-1.rockspec: MD5 = `md5sum $(word 2, $^) | cut -d' ' -f1`
discount-%-1.rockspec: rockspec.in public/dist/lua-discount-%.tar.gz
	@sed "s|%VERSION%|$*|;s|%URL%|$(URL)|;s|%SRCX%|md5 = '$(MD5)'|" $< > $@
	@echo 'Generated: $@'

discount-scm-1.rockspec: SRCX = branch = "master"
discount-scm-1.rockspec: rockspec.in
	@sed 's|%VERSION%|scm|;s|%URL%|$(GITURL)|;s|%SRCX%|$(SRCX)|' $< > $@
	@echo 'Generated: $@'

public/dist/:
	$(MKDIR) $@

check-dist: dist
	sha1sum -c .dist.sha1sums

check-luarocks-build check-luarocks-make: \
check-luarocks-%: | discount-scm-1.rockspec
	$(LUAROCKS) --tree='$(CURDIR)/build/$@' $* $|
	$(RM) -r build/$@/


.PHONY: dist check-dist check-luarocks-make check-luarocks-build
