local utils = {}

--[[
Helper function for finding the first element in a table/array.
]]
function utils.first(t)
  local keys = {}
  for k,_ in pairs(t) do
    table.insert(keys, k)
  end
  
  table.sort(keys)
  
  return t[keys[1]]
end

function utils.includes(t, element)
  for _, e in ipairs(t) do
    if element == e then
      return true
    end
  end
  
  return false
end

return utils
