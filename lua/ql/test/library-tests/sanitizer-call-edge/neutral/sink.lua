local M = {}

function M.doShell(prefix, value)
    os.execute(value)
end

function M.consume(value)
  os.execute(value)
end

return M
