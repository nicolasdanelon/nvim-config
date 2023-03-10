local opt = vim.opt

opt.guicursor = ""

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & inddentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- search
opt.ignorecase = true
opt.smartcase = true

-- appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.showmode = false

-- backspace
opt.backspace = "indent,eol,start"

-- split windows
opt.splitright = true
opt.splitbelow = true

-- no swaps or backups
opt.swapfile = false
opt.backup = false

-- undo file
opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
opt.undofile = true

-- quick refresh
opt.updatetime = 50
