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

