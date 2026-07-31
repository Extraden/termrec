# termrec

`termrec` records complete terminal sessions for later replay and workflow analysis.
It stores terminal input, terminal output, event timing, session metadata, and a
before/after Git snapshot when recording starts inside a repository.

It is **not screen video**. It records the text and terminal control sequences sent
through a pseudo-terminal, so recordings are normally much smaller than MP4 files
and remain replayable with `scriptreplay`.

## Requirements

- Linux
- Bash 4+
- `script` and `scriptreplay` from `util-linux`
- `tar`
- Git is optional

On Ubuntu these tools are normally already installed.

## Install

```sh
git clone https://github.com/Extraden/termrec.git
cd termrec
bash install.sh
```

Make sure `~/.local/bin` is in `PATH`:

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Add that line to `~/.zshrc` to keep it permanently.

## Usage

Record a complete login-shell session:

```sh
termrec
```

Everything launched inside that shell is recorded: Zsh commands, Git, Vim,
Neovim, compilers, debuggers, and other terminal programs. Exit the nested shell
with `exit` or `Ctrl-D` to stop recording.

Record one command:

```sh
termrec vim --clean bigint.cpp
termrec nvim --clean bigint.cpp
termrec make
```

Give a session a readable label:

```sh
termrec --name exam -- vim --clean bigint.cpp
termrec start --name webserv -- zsh -l
```

List recordings:

```sh
termrec list
```

Replay the latest recording, limiting idle pauses to two seconds:

```sh
termrec replay latest
```

Replay twice as fast:

```sh
termrec replay latest --speed 2
```

Show recording metadata:

```sh
termrec summary latest
```

Create a shareable archive:

```sh
termrec pack latest
```

Print the path of a recording:

```sh
termrec path latest
```

Check dependencies:

```sh
termrec doctor
```

## Storage

By default, recordings are stored under:

```text
~/.local/state/termrec/
├── sessions/
└── archives/
```

Change this location with `TERMREC_HOME`:

```sh
export TERMREC_HOME="$HOME/terminal-recordings"
```

A session contains:

```text
input.log          bytes entered into the pseudo-terminal
output.log         terminal output and control sequences
timing.log         timing and stream information
meta.txt           command, directory, terminal, version, exit status
git/               optional before/after status and patches
```

## Vim and Neovim

Exam-style Vim without user configuration:

```sh
termrec --name exam -- vim --clean bigint.cpp
```

Clean Neovim without NvChad or another user configuration:

```sh
termrec --name clean-nvim -- nvim --clean bigint.cpp
```

Normal Neovim with the user's configuration:

```sh
termrec nvim bigint.cpp
```

## What is captured

`termrec` captures bytes that reach the pseudo-terminal. Terminal-emulator or
desktop shortcuts intercepted before that point are not captured. For example,
`Ctrl-Shift-C` may be handled by the terminal itself rather than by the recorded
shell.

The Git snapshot only covers the repository in which `termrec` was started. If a
long shell recording moves between several repositories, their terminal activity
is still recorded, but automatic before/after patches are not collected for every
repository.

## Sensitive input

The input log contains everything delivered to the terminal, including hidden
password input. Recordings are created with permissions restricted to the current
user, but inspect them before sharing or publishing.

Do not commit recordings to this repository. They are stored outside the checkout
by default.

## Development

```sh
make test
```

## License

MIT
