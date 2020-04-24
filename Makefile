PREFIX = ${HOME}

all: mel

mel: mel.sh
	cat mel.sh > mel
	chmod +x mel
	
install:
	mkdir -p $(PREFIX)/bin
	mv mel $(PREFIX)/bin

uninstall:
	rm -rf $(PREFIX)/bin/mel 
