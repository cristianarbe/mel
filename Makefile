PREFIX = /usr/local

all:

install:
	@mkdir -p $(PREFIX)/bin
	@cp mel $(PREFIX)/bin
	@chmod +x $(PREFIX)/bin/mel

uninstall:
	@rm -rf $(PREFIX)/bin/mel 