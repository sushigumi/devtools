local M = {}

function M.setup(spec)
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Load the options. `mapleader` and `maplocalleader` are set up here
  -- so that the mappings in lazy.nvim are correct.
  require("config.options")

  -- Setup lazy.nvim
  require("lazy").setup({
    spec = spec.lazy,
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "tokyonight" } },
  })

  vim.cmd.colorscheme("tokyonight")

  -- Setup keymaps
  require("config.keymaps")

  -- Enhance the global variables with additional configuration defined in the spec.
  _G.lspenable = spec.lspenable
end

return M
