# Neovim Setup Documentation

This document provides an overview of the Neovim setup and configurations defined in the `cond.lua` file. Below is a breakdown of the key features and customizations included in the setup.

---

## Key Mappings

### Leader Key Configuration
- `<leader>`: Space key (`" "`).

#### Essentials
- `;` → `:`: No need to use the shift key for commands.
- `H` → `^`: Move to the start of the line.
- `L` → `$`: Move to the end of the line.

### File Management
- `<leader>x`: Save and quit the file.
- `<leader>w`: Save the current file.
- `<leader>q`: Quit the current file.

### Search and Highlight
- `<leader>h`: Remove search highlight.

### Window Management
- `<leader>sv`: Split window vertically.
- `<leader>sh`: Split window horizontally.
- `<leader>se`: Make all splits equal size.
- `<leader>sx`: Close the current split.
- `<leader>sm`: Toggle maximized window (requires vim-maximizer plugin).

### File Explorer
- `<leader>e`: Toggle file explorer (requires Nvim-Tree plugin).

### Telescope (Fuzzy Finder)
- `<leader>ff`: Find files.
- `<leader>fg`: Live grep search.
- `<leader>fb`: List open buffers.
- `<leader>fh`: Show help tags.

### LSP and Code Actions
- `<leader>ca`: Trigger code actions (requires Lspsaga plugin).
- `<leader>rn`: Rename symbol (requires Lspsaga plugin).
- `<leader>D`: Show line diagnostics (requires Lspsaga plugin).
- `<leader>d`: Show cursor diagnostics (requires Lspsaga plugin).
- `<leader>o`: Show outline (requires Lspsaga plugin).

### TypeScript-Specific Commands
- `<leader>rf`: Rename a file (requires TypeScript plugin).
- `<leader>oi`: Organize imports (requires TypeScript plugin).
- `<leader>ru`: Remove unused imports (requires TypeScript plugin).

### Additional LSP Mappings
- `<leader>vws`: Search workspace symbols.
- `<leader>vd`: Open diagnostics floating window.
- `<leader>cr`: Show references.
- `<leader>rn`: Rename a symbol.

### Formatting
- `<Leader>f`: Format selected text in normal mode.
- `<Leader>f`: Format selected text in visual mode.

#### Navigation
- `<C-d>`: Half-page down and center the cursor.
- `<C-u>`: Half-page up and center the cursor.

---

## Install
mkdir -p $HOME/.config/nvim

git clone https://github.com/nicolasdanelon/nvim-config $HOME/.config/nvim

### An arctic, north-bluish clean and elegant iTerm2 color scheme.

https://github.com/arcticicestudio/nord-iterm2

### Monaco font patched with extra nerd glyphs

https://github.com/Karmenzind/monaco-nerd-fonts

### prettierd, a daemon, for ludicrous formatting speed.

```
npm install -g @fsouza/prettierd
```

https://github.com/fsouza/prettierd

### Kitty themes
https://github.com/dexpota/kitty-themes (Later_This_Evening)
