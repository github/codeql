local M = {}

function M.run(cmd)
  return os.execute(cmd)
end

return M
