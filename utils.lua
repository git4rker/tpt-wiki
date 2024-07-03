local utils = {}

--[[
Nonblocking GET fetcher
]]
local fetchTasks = {}

local function cleanFetchTasks()
  for i=#fetchTasks,1,-1 do
    if fetchTasks[i].remove == true then
      table.remove(fetchTasks, i)
    end
  end
end

local function updateFetchTask(task)
  if task.request == nil or task.callback == nil then
    return
  end

  if task.request:status() == "done" then
    task.callback(task.request:finish())
    task.remove = true
  end
end

local function updateFetchTasks()
  cleanFetchTasks()

  for _, task in ipairs(fetchTasks) do
    updateFetchTask(task)
  end
end

function utils.fetch(uri, callback)
  table.insert(fetchTasks, {
    request = http.get(uri),
    callback = callback,
    remove = false
  })
end

event.register(event.TICK, updateFetchTasks)

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
