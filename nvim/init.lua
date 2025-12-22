-- Terminal mode: use Esc to exit to normal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key (space is common)
vim.g.mapleader = " "

-- Load plugins
require("lazy").setup("plugins")
