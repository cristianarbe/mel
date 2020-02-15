PREFIX = .
LIBS = change add

all: $(LIBS) mel

install:
	@mkdir -p $(PREFIX)/bin $(PREFIX)/lib/mel
	@mv mel $(PREFIX)/bin
	@mv $(LIBS) $(PREFIX)/lib/mel

uninstall:
	@rm -rf $(PREFIX)/bin/mel $(PREFIX)/lib/mel

clean:
	@rm -f mel $(LIBS)