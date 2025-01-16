# Tmux Cheat Sheet

## Tmux Commands

### Launching tmux

#### Create a new session

```shell
tmux
```

#### Create a new (named) session

```shell
tmux new -s session-name
```

#### List existing sessions

```shell
tmux list-sessions or tmux ls
```

#### Attach to most recent session

```shell
tmux attach-session or tmux a
```

#### Attach to an existing session

```shell
tmux attach-session -t session-name or tmux a -t session-name
```

#### Terminate an existing session

```shell
tmux kill-session -t session-name
```

#### Terminate the current session

```shell
Ctrl + b, x
```

### Panes

#### Split the window vertically

```shell
Ctrl + b, %
```

#### Split the window horizontally

```shell
Ctrl + b, "
```

#### Move focus to another pane

```shell
Ctrl + b, [left arrow, up arrow, down arrow, right arrow]
```

#### Move active pane to left or right

```shell
Ctrl + b, { or }
```

#### Toggle pane zoom

```shell
Ctrl + b, z
```

#### Kill pane

```shell
Ctrl + b, x
```

#### Resize pane

```shell
Ctrl + b, Ctrl [left arrow, up arrow, down arrow, right arrow]
```

### Sessions

#### Open session switcher

```shell
Ctrl + b, s
```

#### Rename your current session

```shell
Ctrl + b, $
```

####  Move to previous or next session

```shell
Ctrl + b, ( or )
```

### Windows

#### Create a new window

```shell
Ctrl + b, c
```

#### Rename the current window

```shell
Ctrl + b, , (comma)
```

#### Close the current window

```shell
Ctrl + b, &
```

#### Move to the next window

```shell
Ctrl + b, n
```

#### Move to the previous window

```shell
Ctrl + b, p
```

### Tmux commands

#### Enter command mode

```shell
Ctrl + b, :
```

- Create a new session: `new`
- Create a new named session: `new -s session-name`
- Display buffer contents: `show-buffer`
- List keys: `list-keys`