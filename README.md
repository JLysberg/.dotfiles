# Dotfiles

Personal configuration for an Omarchy-based Linux environment, collected in a
single repository and linked into the XDG config directory.

## Configurations

| Directory | Configuration |
| --- | --- |
| `darkman/` | Dark and light theme integration |
| `git/` | Git defaults, aliases, and credentials |
| `hypr/` | Hyprland, Hypridle, Hyprlock, and related scripts |
| `nvim/` | Omarchy-adapted LazyVim setup |
| `tmux/` | tmux bindings and behavior |
| `omarchy/` | Omarchy shell layout, plugins, backgrounds, and hooks |

Each non-hidden top-level directory is treated as a config and mapped directly
to the same name under `${XDG_CONFIG_HOME:-$HOME/.config}`. Root-level files,
such as `bootstrap`, are ignored by discovery.

## Bootstrap

Clone the repository and run the bootstrap script:

```bash
git clone git@github.com:JLysberg/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap
```

To process only specific configs, pass their names as arguments:

```bash
./bootstrap nvim tmux
```

The script performs a complete conflict check before changing anything. For
each selected config, it will:

- leave an existing correct symlink unchanged;
- create a relative symlink when the target is missing;
- back up an identical real target before replacing it with a symlink;
- abort the entire run if a target differs or points somewhere else; or
- skip the config when it exists in neither location.

Backups are placed beside the XDG config directory and named like
`.config.before-dotfiles-<timestamp>-<pid>`.

### Absorbing a config

A target that exists under `~/.config` but not in the repository can be
imported by naming it explicitly:

```bash
./bootstrap ghostty
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
