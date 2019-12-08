# Mel

Ed-like editor written in posix-compliant shell.

## Getting Started

### Prerequisites

- A POSIX-compliant shell

### Installing

To use mel:

```
$ test ! -d ~/.local/bin && mkdir -p ~/.local/bin/
$ wget https://raw.githubusercontent.com/cristianarbe/mel/master/mel -O ~/.local/bin/mel
```

If after this, you get

```
bash: mel: command not found
```

Add `.local/bin` to your path with:

```
$ echo 'export PATH="$PATH:~/.local/bin/"' > ~/.bashrc
$ . ~/.bashrc
```

## Usage

### Available commands

* `p`: print the whole file
* `p N`: print line N
* `/ WORD`: search for WORD
* `c N`: change line number N
* `! COMMAND`: run COMMAND in the shell
* `a`: appends to the end of the file
* `a N`: inserts line(s) after line N
* `d N`: deletes line N
* `u`: undo last change
* `w`: saves
* `wq`: saves and quits
* `q`: quits
* `e FILE`: closes the current file (without saving) and opens FILE
* `f`: shows the path of the open file

### Editing

For the commands that require text input:

1. Write as you would normally do, presing enter for a new line.
2. After the last line is written, press enter again.
3. Press `Ctrl+D` to finish the text input.


## Authors

- **Cristian Ariza** - _Initial work_ - [cristianarbe](https://github.com/cristianarbe)

See also the list of [contributors](https://github.com/cristianarbe/mel/contributors) who participated in this project.

## License

This project is licensed under the GPLv3 - see the [LICENSE](LICENSE) file for details
