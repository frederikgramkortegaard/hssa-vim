# hssa-vim

Vim / Neovim syntax highlighting for **HSSA** (Hybrid Static Single Assignment),
a reversible-computing intermediate representation.

Highlights relations (`rel`, `import`), the distinguished `begin`/`end` block
labels, builtin operations (`add`, `sub`, `subfrom`, `mul`, `euclidiv`, `dup`,
`id`, `discard`, the comparisons, `and`/`or`/`xor`, and the dotted memory / test
ops `mmem.new`, `mmem.allocate`, `mmem.readwrite`, `mmem.read`, `tests.fail`,
`tests.assert`, `array.*`), the inversion prefix `~`, integer and `'c'` literals,
the unit value `()`, SSA value suffixes like `v.1`, `//` line comments, and, most
importantly, the four backbone operators `:=`, `=:`, `->`, `<-`.

All colours are linked to standard highlight groups (`Keyword`, `Operator`,
`Comment`, `Number`, `Function`, `Special`, `Constant`, `Delimiter`,
`Identifier`), so the plugin respects whatever colorscheme you use.

## Layout

```
hssa-vim/
├── ftdetect/hssa.vim   " sets filetype=hssa for *.hssa
├── syntax/hssa.vim     " the syntax definition
└── README.md
```

## Install

### Native Vim 8+ / Neovim packages (no plugin manager)

Vim:

```sh
mkdir -p ~/.vim/pack/plugins/start
cp -r hssa-vim ~/.vim/pack/plugins/start/hssa-vim
```

Neovim:

```sh
mkdir -p ~/.config/nvim/pack/plugins/start
cp -r hssa-vim ~/.config/nvim/pack/plugins/start/hssa-vim
```

### Manual runtimepath

Drop the files anywhere and add the directory to `runtimepath` in your
`vimrc` / `init.vim`:

```vim
set runtimepath^=/path/to/hssa-vim
```

### lazy.nvim

```lua
{
  "frederikgramkortegaard/hssa-vim",
  ft = "hssa",
}
```

Or point it at a local checkout:

```lua
{ dir = "/path/to/hssa-vim", ft = "hssa" }
```

### packer.nvim

```lua
use { "frederikgramkortegaard/hssa-vim" }
```

### vim-plug

```vim
Plug 'frederikgramkortegaard/hssa-vim'
```

## Notes

- Filetype detection fires on the `*.hssa` extension. To force it on an open
  buffer: `:setfiletype hssa`.
- HSSA only permits full-line `//` comments; for editing convenience this plugin
  also highlights trailing `//...` to end of line.
