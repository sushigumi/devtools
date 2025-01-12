local function get_lsp_clients(opts)
  local ret = {}
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end

  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = function()
      return {
        on_attach = function(client, buffer, keys)
          -- Shared language server mappings
          local bufopts = { noremap = true, silent = true, buffer = buffer }
          for _, spec in pairs(keys["*"]) do
            vim.keymap.set(spec.mode or "n", spec[1], spec[2], bufopts)
          end

          local clients = get_lsp_clients({ bufnr = buffer })
          for _, client in ipairs(clients) do
            for _, spec in pairs(keys[client.name] or {}) do
              vim.keymap.set(spec.mode or "n", spec[1], spec[2], bufopts)
            end
          end
        end,
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            }
          }
        },
        keys = {
          clangd = {
            { "<leader><leader>", "<Cmd>ClangdSwitchSourceHeader<CR>", desc = "Switch Source/Header (C/C++)" },
          },
          ["*"] = {
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
            { "gi", vim.lsp.buf.implementation, desc = "Goto implementation",  desc = "Goto Implementation"},
            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
            { "K", vim.lsp.buf.hover, desc = "Hover" },
            { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
            { "<space>ca", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action" },
            { "<space>f", function() vim.lsp.buf.format { async = true } end, desc = "Code Format" },
          }
        },
        servers = {
          "clangd",
          "gopls",
        },
      }
    end,
    config = function(_, opts)
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = opts.capabilities,
          on_attach = function(client, buffer)
            opts.on_attach(client, buffer, opts.keys)
          end,
        }, require("langservers." .. server) or {})

        require("lspconfig")[server].setup(server_opts)
      end

      for _, server in ipairs(opts.servers) do
        if _G.lspenable[server] then
          setup(server)
        end
      end
    end
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    opts = function() 
      local cmp = require("cmp")
      return {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        })
      }
    end,
  }
}
