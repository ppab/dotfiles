## Closest to VS Code’s Cmd+D is using search + gn:

Put cursor on `foo`.

Hit `*` → this searches for foo.

Type `cgn` → Vim selects the next foo and puts you in insert mode to replace it.

Type your replacement (say, bar).

Press `<Esc>`.

Hit `.` (dot) → repeats the last change on the next match.

Keep pressing . to change every subsequent foo to bar.

to repeat on the next match (use n/N to jump forward/backward).


## Open nvim in diff mode
 nvim -d package.json package2.json


## Vertical (Column) Multi-Cursor
### Visual Block Mode (<C-v>) + I or A

This is native Vim/Neovim functionality — and works perfectly in LazyVim:

Move your cursor to the top line you want to edit

Press **Ctrl-v** (enter visual block mode)

Use j/k to move down/up and select the lines

Press **I** to insert at the start of each line
(or press **A** to insert at the end)

Type your text

Press **Esc** — it will apply the change to all selected lines

