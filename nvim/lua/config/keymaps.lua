-- Helper around vim.keymap.set
local function map(mode, lhs, rhs, opts)
  local modes = type(mode) == "string" and { mode } or mode

  if #modes > 0 then
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or BufNewFile
  return function()
    go({ severity = severity })
  end
end
map("n", "<space>e", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { noremap = true, silent = true, desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { noremap = true, silent = true, desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { noremap = true, silent = true, desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { noremap = true, silent = true, desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { noremap = true, silent = true, desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { noremap = true, silent = true, desc = "Prev Warning" })
