default:

install:
	shellcheck mel -x -e 1090
	mkdir -p ~/.local/bin/
	rm -rf ~/.local/bin/mel
	cp mel ~/.local/bin/
	chmod +x ~/.local/bin/mel
