local M = {}

---@param env { [string]: string }
---@return nil
function M.env_table(env)
  for k, v in pairs(env) do
    hl.env(k, v)
  end
end

---@generic T table
---@param base T
---@param overrides T
---@return T
function M.merge_tables(base, overrides)
  local result = {}
  for k, v in pairs(base) do result[k] = v end
  for k, v in pairs(overrides) do result[k] = v end
  return result
end

return M
