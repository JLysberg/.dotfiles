# Dotfiles

Personal configuration shared between Omarchy and WSL Ubuntu systems,
collected in a single repository and linked into the XDG config directory.

## Configurations

| Directory  | Configuration                                         |
| ---------- | ----------------------------------------------------- |
| `darkman/` | Dark and light theme integration                      |
| `git/`     | Git defaults, aliases, and credentials                |
| `hypr/`    | Hyprland, Hypridle, Hyprlock, and related scripts     |
| `mise/`    | Shared tools and the WSL-specific tool profile        |
| `nvim/`    | Omarchy-adapted LazyVim setup                         |
| `tmux/`    | tmux bindings and behavior                            |
| `omarchy/` | Omarchy shell layout, plugins, backgrounds, and hooks |

Each non-hidden top-level directory is treated as a config and mapped directly
to the same name under `${XDG_CONFIG_HOME:-$HOME/.config}`. Root-level files
such as the bootstrap helpers are ignored by discovery.

## Bootstrap helpers

Clone the repository first:

```bash
git clone git@github.com:JLysberg/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Omarchy

Link all non-hidden configuration directories:

```bash
./bootstrap-configs
```

To link only selected configurations, pass their names explicitly:

```bash
./bootstrap-configs nvim tmux
```

### WSL Ubuntu

Run the WSL bootstrap to install system packages, link the applicable
configurations, install mise tools, and select Zsh as the default shell:

```bash
./bootstrap-wsl
```

The WSL bootstrap activates the `wsl` mise environment while installing tools.
Interactive Zsh sessions select the same environment automatically when
`WSL_DISTRO_NAME` is present. Shared tools live in `mise/config.toml`, while
WSL-only tools such as Neovim live in `mise/config.wsl.toml`.

### Linking behavior

`bootstrap-configs` performs a complete conflict check before changing
anything. For each selected config, it will:

- leave an existing correct symlink unchanged;
- create a relative symlink when the target is missing;
- back up an identical real target before replacing it with a symlink;
- abort the entire run if a target differs or points somewhere else; or
- skip the config when it exists in neither location.

Backups are placed beside the XDG config directory and named like
`.config.before-dotfiles-<timestamp>-<pid>`.

### Tmux plugins

Install TPM and the plugins declared in the tmux config separately:

```bash
./install-tmux-plugins
```

TPM stores its plugin checkouts under `~/.local/share/tmux/plugins`, outside
this repository. Once installed, use `prefix + U` inside tmux to update them.

### Tmux projects

The `t` shell alias starts or attaches to a tmux session rooted at a Git
repository beneath `~`. The session name is derived from its home-relative
path, so `t osirion` opens `~/dev/osirion` in a session named `dev-osirion`.
Home-relative paths and nested worktrees are also supported:

```bash
t osirion
t .dotfiles
t osirion/.worktrees/new-renderer
```

Run `t` without an argument to discover Git repositories and worktrees beneath
`~` and select one with `fzf`. Discovery includes standalone repositories,
top-level hidden repositories, and linked Git worktrees. Nested clones and
repositories beneath hidden tool-storage paths are filtered out. Inside tmux,
the same command switches the current client instead of nesting another tmux
instance. `prefix + C` opens this picker in a popup, while `prefix + S` shows
the tree of existing sessions and windows. The discovered repository list is
cached under `$XDG_CACHE_HOME/tmux` and refreshed atomically in the background,
so subsequent picker launches open immediately.

### Absorbing a config

A target that exists under `~/.config` but not in the repository can be
imported by naming it explicitly:

```bash
./bootstrap-configs ghostty
```

The target is moved into `.dotfiles/ghostty` and replaced with a symlink. The
new config is deliberately left unstaged so it can be reviewed before it is
committed.

## Applying desktop changes

Hyprland normally reloads configuration automatically, but it can be validated
explicitly after a migration or update:

```bash
hyprctl reload
hyprctl configerrors
```

The Omarchy shell hot-reloads its configuration and user plugins.
