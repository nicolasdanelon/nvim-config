vim.g.mapleader = " "

local vfn = vim.fn
local keymap = vim.keymap

-- General keymaps --
-- --------------- --

keymap.set("n", "<C-r>%", function()
  local filepath = vfn.expand("%")
  vfn.setreg("+", filepath)
  print("Route on clipboard: " .. filepath)
end, { silent = true })

-- the essentials
keymap.set("n", ";", ":") -- no shift
keymap.set("n", "H", "^") -- start off line
keymap.set("n", "L", "$") -- EOL

-- basic quit & save
keymap.set("n", "<leader>x", ":x<cr>")
keymap.set("n", "<leader>w", ":w<cr>")
keymap.set("n", "<leader>q", ":q<cr>")

-- center on page navigation
keymap.set("n", "<c-d>", "<c-d>zz") -- halp page down
keymap.set("n", "<c-u>", "<c-u>zz") -- half page up
keymap.set("n", "<c-f>", "<c-f>zz") -- full page forward
keymap.set("n", "<c-b>", "<c-b>zz") -- full page back

-- no search highlight
keymap.set("n", "<leader>h", ":nohl<cr>")

-- remove without adding to clipboard
keymap.set("n", "x", '"_x"')

-- increment and decrement a number
keymap.set("n", "+", "<c-a>")
keymap.set("n", "-", "<c-x>")

-- split
keymap.set("n", "<leader>sv", "<c-w>v")
keymap.set("n", "<leader>sh", "<c-w>s")
keymap.set("n", "<leader>se", "<c-w>=")
keymap.set("n", "<leader>sx", ":close<cr>")

-- Splits traveler
keymap.set("n", "<c-h>", "<c-w>h")
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<c-k>", "<c-w>k")
keymap.set("n", "<c-l>", "<c-w>l")

-- plugins
-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<cr>")

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")

-- telescope
local builtin = require('telescope.builtin')
keymap.set('n', '<leader>ff', builtin.find_files, {})
keymap.set('n', '<leader>fg', builtin.live_grep, {})
keymap.set('n', '<leader>fb', builtin.buffers, {})
keymap.set('n', '<leader>fh', builtin.help_tags, {})

local status, _ = pcall(vim.cmd, "colorscheme nord") -- frappe

if not status then
  print("Colorscheme not found!")
  return
end

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
local setup, autopairs = pcall(require, "nvim-autopairs")
if not setup then
  return
end

autopairs.setup()

local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
  return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<c-k>"] = actions.move_selection_previous,
        ["<c-j>"] = actions.move_selection_next,
        ["<c-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
})

telescope.load_extension("fzf")

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
  return
end

local luasnip_status, luasnip = pcall(require, "luasnip")
if not luasnip_status then
  return
end

local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
  return
end

-- load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<c-k>"] = cmp.mapping.select_prev_item(),
    ["<c-j>"] = cmp.mapping.select_next_item(),
    ["<c-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1)),
    ["<c-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1)),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end),
    ["<c-e>"] = cmp.mapping.abort(),
    ["<cr>"] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = {
    format = lspkind.cmp_format({
      -- maxwidth = 180,
      -- ellipsis_char = "...",
    fields = { "kind", "abbr", "menu" },
    format = function (entry, item)
      -- item.kind = string.format("%s", item.kind)
      item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return item
    end,
    }),
  },
  window = {
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true
  }
})

local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- strongly advised by the plugin docs
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
  actions = {
    open_file = {
      window_picker = {
        enable = false
      },
    },
  },
})

local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end


local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
  return
end

local keymap = vim.keymap

-- enable keybinds for available lsp server
local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
  keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
  keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
  keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
  keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
  keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
  keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts)

  -- typescript-specific keymaps
  if client.name == "tsserver" then
    keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
    keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
    keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
  end
end

-- enable autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

typescript.setup({
  server = capabilities,
  on_attach = on_attach,
})

lspconfig["html"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig["cssls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig["rust_analyzer"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

lspconfig["tailwindcss"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- todo check if works
lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vfn.expand("$VIMRUNTIME/lua")] = true,
          [vfn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  return
end

mason.setup()

mason_lspconfig.setup({
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "rust_analyzer"
  }
})

local status, lualine = pcall(require, "lualine")
if not status then
  return
end

local lualine_nord = require("lualine.themes.nord")

lualine.setup({
  options = {
    theme = lualine_nord
  }
})


local lsp_status, lsp = pcall(require, "lsp-zero")
if not lsp_status then
  return
end

local cmp_status, cmp = pcall(require, "cmp")
if not cmp_status then
  return
end

lsp.preset('recommended')

lsp.ensure_installed({
  "tsserver",
  "html",
  "cssls",
  "tailwindcss",
  "lua_ls",
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
  ['<c-Space>'] = cmp.mapping.complete(),
})

lsp.set_preferences({
  sign_icons = { }
})

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})


lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  local keymap = vim.keymap

  keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
  keymap.set("n", "<leader>cr", function() vim.lsp.buf.references() end, opts)
  keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
  keymap.set("i", "<C-h>rn", function() vim.lsp.buf.signature_help() end, opts)
end
)

lsp.setup()

local status, gitsigns = pcall(require, "gitsigns")
if not status then
  return
end

gitsigns.setup()
local setup, comment = pcall(require, "Comment")
if not setup then
  return
end

comment.setup()

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

local status, prettier = pcall(require, "prettier")
if not status then
  print "hey!"
  return
end

prettier.setup({
  bin = 'prettierd',
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  cli_options = {
    arrow_parens = "always",
    bracket_spacing = true,
    bracket_same_line = false,
    embedded_language_formatting = "auto",
    end_of_line = "lf",
    html_whitespace_sensitivity = "css",
    -- jsx_bracket_same_line = false,
    jsx_single_quote = false,
    print_width = 200,
    prose_wrap = "preserve",
    quote_props = "as-needed",
    semi = true,
    single_attribute_per_line = false,
    single_quote = false,
    tab_width = 2,
    trailing_comma = "es5",
    use_tabs = false,
    vue_indent_script_and_style = false,
    config_precedence = "prefer-file",
  },
})

local ensure_packer = function()
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)
  use("wbthomason/packer.nvim")

  -- required by many nvim plugins
  use("nvim-lua/plenary.nvim")

  -- file explorer
  use("nvim-tree/nvim-tree.lua")

  -- icons
  use("nvim-tree/nvim-web-devicons")

  -- maximizes and restores current window
  use("szw/vim-maximizer")

  -- nice, smooth colorscheme
  use("arcticicestudio/nord-vim")

  -- the essentials
  use("tpope/vim-surround")
  use("vim-scripts/ReplaceWithRegister")

  -- commenting with gc
  use("numToStr/Comment.nvim")

  -- Auto-pairs
  use("windwp/nvim-autopairs")

  -- statusline
  use("nvim-lualine/lualine.nvim")

  -- fuzzy finder
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

  -- git
  use("lewis6991/gitsigns.nvim")

  -- snippets
  use("L3MON4D3/LuaSnip")
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")

  -- autocompletion
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")

  -- LSP support
  use("neovim/nvim-lspconfig")
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("onsails/lspkind.nvim")

  -- LSP servers
  use("jose-elias-alvarez/typescript.nvim")

  -- formatting
  use("MunifTanjim/prettier.nvim")

  if packer_bootstrap then
    require('packer').sync()
  end
end)

