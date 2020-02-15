# mel

Ed-like editor written in POSIX shell.

## Why

Because I wanted to see whether you can make a functional text editor by only using POSIX shell commands. Also, because you can have an editor wherever there is a shell.

## Installing

To use `mel`:

```
$ git clone https://github.com/cristianrz/mel.git
$ cd mel
$ make install
```

If after this, you get

```
mel: command not found
```

Add `.local/bin` to your path with:

```
$ echo 'export PATH="$PATH:~/.local/bin/"' > ~/.bashrc
$ . ~/.bashrc
```

## Usage

### Available commands

- `! [COMMAND]`: run COMMAND in the shell
- `/ [PATTERN]`: search for PATTERN in the file
- `a [#LINE]`: insert line(s) after #LINE
- `a`: appends to the end of the file
- `c [#LINE]`: change #LINE
- `d [#LINE]`: delete #LINE
- `e [FILE]`: close the current file (without saving) and opens FILE
- `p [#LINE]`: print LINE
- `p`: print the whole file
- `q`: quits
- `u`: undo last change
- `w`: save
- `wq`: save and quit

### Editing

For the commands that require text input:

1. Write as you would normally do, presing enter for a new line.
2. After the last line is written, press enter again.
3. Press `Ctrl+D` to finish the text input.

## Authors

- **Cristian Ariza** - _Initial work_ - [cristianrz](https://github.com/cristianrz)

See also the list of [contributors](https://github.com/cristianrz/mel/contributors) who participated in this project.

## License

This project is licensed under the GPLv3 - see the [LICENSE](LICENSE) file for details
