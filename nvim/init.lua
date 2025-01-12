local lspenable = {
  clangd = true,
  gopls = true,
}

require("config.lazy").setup({
    lazy = { import = "plugins" },
    lspenable = lspenable,
})
