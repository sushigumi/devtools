-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = "\\"
vim.g.maplocalleader = ","

local opt = vim.opt
opt.expandtab = true -- Use spaces instead of tabs
opt.number = true -- Print line number
opt.relativenumber = true -- Enable relative line numbers
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
