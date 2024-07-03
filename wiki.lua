local font = require("./font")
local json = require("./json")
local utils = require("./utils")
local drawText = require("./drawText")

-- fetch("https://powdertoy.co.uk/Wiki/api.php?action=query&format=json&rvprop=content&prop=revisions&titles=Element:DUST", function(content, status, headers)
--     local parsed = json.parse(content)
--     print(first(first(parsed["query"]["pages"])["revisions"])["*"])
-- end)

local browser = {}

browser.window = ui.window(-1, -1, 500, 300)
browser.open = false
browser.width, browser.height = browser.window:size()
browser.wGap = (gfx.WIDTH - browser.width) / 2 -- gap between the master window border and browser
browser.hGap = (gfx.HEIGHT - browser.height) / 2 -- same for height

browser.searchBar = ui.textbox(5, 5, browser.width - 30, 15, nil, "[search]")
browser.searchButton = ui.button(browser.width - 20, 5, 15, 15, "S")
browser.textView = {}
browser.textView.x = browser.wGap + 5
browser.textView.y = browser.hGap + 25
browser.textView.width = browser.width - 10
browser.textView.height = browser.height - 25
browser.textView.visible = true
browser.textView.text = "meow! Press the search button :)"

browser.window:addComponent(browser.searchBar)
browser.window:addComponent(browser.searchButton)

local function renderBrowserGFX()
  -- gfx.setClipRect(browser.textView.x, browser.textView.y, browser.textView.width, browser.textView.height)
  -- gfx.drawText(browser.textView.x, browser.textView.y, browser.textView.text)
end

local function openBrowser()
  browser.open = true
  ui.showWindow(browser.window)
end

local function closeBrowser()
  browser.open = false
  ui.closeWindow(browser.window)
end

event.register(event.KEYPRESS, function(key, scan, rep, shift, ctrl, alt)
  if key == ui.SDLK_x then
    openBrowser()
  end
end)

browser.window:onTryExit(closeBrowser)
browser.window:onDraw(renderBrowserGFX)
browser.searchButton:action(function()
  browser.textView.text = "Loading..."
end)

