PREFIX = .

all: mel

install:
	@mkdir -p $(PREFIX)/bin
	@mv mel $(PREFIX)/bin

uninstall:
	@rm -rf $(PREFIX)/bin/mel 

clean:
	@rm -f mel 