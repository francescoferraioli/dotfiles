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
- https://github.com/sharkdp/fd
- https://github.com/sharkdp/bat
- https://github.com/stedolan/jq