https://medium.com/@Clovis_app/configuration-of-a-beautiful-efficient-terminal-and-prompt-on-osx-in-7-minutes-827c29391961

HammerSpoon
https://github.com/jasonrudolph/keyboard

James's `~/.hammerspoon/init.lua`:
```
keyUpDown = function(modifiers, key)
  hs.eventtap.keyStroke(modifiers, key, 0)
end

require('keyboard.control-escape')
require('keyboard.microphone')
require('keyboard.windows')
```

sudo chsh -s /bin/zsh

Fresh?

- https://github.com/junegunn/fzf
- https://github.com/BurntSushi/ripgrep
```
brew install ripgrep
```
- https://github.com/sharkdp/fd
- https://github.com/sharkdp/bat
```
brew install bat
```
- https://github.com/stedolan/jq
```
brew install jq
```
- https://github.com/so-fancy/diff-so-fancy
```
npm install -g diff-so-fancy
```
- https://github.com/jwilm/alacritty
```
brew cask install alacritty
```
- https://github.com/tmux/tmux
```
brew install tmux
```
- https://github.com/jamesottaway/tmux-up
```
curl -L https://git.io/tmux-up -o /usr/local/bin/tmux-up
```
