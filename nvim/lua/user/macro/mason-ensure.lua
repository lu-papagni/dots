local M = {}
local MASON_PATH = vim.fn.stdpath('data') .. '/mason'

--- Controlla che siano installati i DAP elencati
--- @param modules string[]
local function ensure(modules)
  if modules and #modules > 0 then
    local cmd = "MasonInstall"
    local file_exists = vim.fn.filereadable

    for _, modname in ipairs(modules) do
      if file_exists(MASON_PATH .. '/bin/' .. modname) == 0
      then
        cmd = cmd .. ' ' .. modname
      end
    end

    if cmd ~= "MasonInstall" then
      vim.cmd(cmd)
    end
  end
end

M.ensure = ensure

return M
