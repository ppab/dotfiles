# Tmux Lessons Summary
##
```bash
leader + c # create window
leader + n # next window
leader + p # previous window
leader + 0,1,2 # navigate to window number.

leader %  #split windo vertically
leader "" #split window horisontally

leader : # enter command mode.
leader : rename-window # enter command mode and rename-window 

leader d #detach from tmux

#sessions
leader 


tmux ls #list all sessions
tmux attach # attach to last session.

```

> tmux conf lives in ~/.tmux.conf






## How to configure your tmux-session.





## Copy Mode Basics
- Enter copy mode: `Ctrl-b [`
- Navigate with vi keys: `h/j/k/l`
- Exit copy mode: `q` or `Escape`

## Selection Types
- **Line selection**: `v` → move → `y`
- **Full line selection**: `V` → move → `y` 
- **Rectangle selection**: `v` → `Ctrl-v` → move → `y`

## Navigation in Copy Mode
- `0` - Beginning of line
- `$` - End of line  
- `^` - First non-whitespace character
- `w/b` - Word forward/backward
- `gg/G` - Top/bottom of buffer
- `H/L` - Top/bottom of screen

## Essential Config (add to ~/.tmux.conf)
```bash
# Vi mode
setw -g mode-keys vi

# Copy to system clipboard
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"

# Rectangle selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

# Config reload
unbind r
bind r source-file ~/.tmux.conf
```

## Workflow
1. `Ctrl-b [` - Enter copy mode
2. Navigate to start position
3. `v` - Start selection (or `V` for line, `Ctrl-v` for rectangle)
4. Navigate to end position
5. `y` - Copy to clipboard
6. Switch panes and paste with `Cmd+V` anywhere

## Rectangle Selection Use Case
Perfect for copying columns of data:
```
Name     Age    City
John     25     NYC
Jane     30     LA  
```
Select just the Age column: position cursor, `v`, `Ctrl-v`, move down, `y`
