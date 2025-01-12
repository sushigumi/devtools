-- If clangd doesn't exist, try clangd-${version}
local function get_binary()
  local default = "clangd"
  if vim.fn.executable(default) == 1 then
    return default
  end

  for i = 18, 16, -1 do
    local versioned_bin = "clangd-" .. i
    if vim.fn.executable(versioned_bin) == 1 then
      return versioned_bin
    end
  end

  return default
end

return {
  cmd = { get_binary() },
}
