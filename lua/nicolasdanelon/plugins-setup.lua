local ensure_packer = function()
  local fn = vim.fn
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
  use("jose-elias-alvarez/null-ls.nvim")
  use("MunifTanjim/prettier.nvim")

  if packer_bootstrap then
    require('packer').sync()
  end
end)

