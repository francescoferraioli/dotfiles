# Installation

Install chocolately: https://chocolatey.org/install

Install nvm: https://github.com/coreybutler/nvm-windows
Run: `nvm install latest`
Run: `nvm use %INSERT_LATEST%`

In a windows command prompt session running as administrator run

```
.\dotfiles\windows\once.cmd
```

## Caps Lock -> Escape

You need to update the key registry.
Follow the instructions [here](https://vim.fandom.com/wiki/Map_caps_lock_to_escape_in_Windows#:~:text=To%20apply%20the%20changes%2C%20log,and%20you%20cannot%20generate%20ScrollLock).).
I have copied the contents in this repo for simplicity in `windows/caps-lock-to-escape`.

*PowerToys does offer a remapping but I've found it to be buggy.*

## Apps to install

- [PowerToys](https://docs.microsoft.com/en-us/windows/powertoys/install)
- [GIT](https://git-scm.com/downloads)
- [Alt-Tab Terminator](https://www.ntwind.com/software/alttabter.html)
  - Key can be found in 1Password
