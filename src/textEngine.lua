local textEngine = {}

local utils = require("./utils")

---@param font { string: integer[][] }
---@param text string
---@param x integer
---@param y integer
---@param w integer
---@param fontSize 1|2|3?
---@param lineSpacing integer?
---@param charSpacing integer?
function textEngine.drawText(font, text, x, y, w, fontSize, lineSpacing, charSpacing) 
  fontSize = fontSize or 1
  lineSpacing = lineSpacing or 4
  charSpacing = charSpacing or 1

  local breakOn = {" ", "-"}
  local consumable = {" "}

  ---@type { text: string, width: integer }[]
  local words = {}
  local wordBuffer = ""

  for i = 1, #text do
    local char = text:sub(i, i)

    if utils.includes(breakOn, char) or i == #text then
      if #wordBuffer > 0 then
        table.insert(words, { text = wordBuffer })
        wordBuffer = ""
      end

      table.insert(words, { text = char })
    else
      wordBuffer = wordBuffer .. char
    end

  end


  for i, word in ipairs(words) do
    local width = 0

    for j = 1, #word.text do
      local charCode = string.byte(word.text:sub(j, j))

      if font[charCode] == nil then
        error("Character '" .. charCode .. "' not defined in font")
      end

      width = width + #font[charCode][1]
    end

    words[i].width = width
  end

  -- No wonky variable size characters please
  local fontHeight = #font[97]

  local cursorX = 0
  local cursorY = 0

  for _, word in ipairs(words) do
    local consume = false

    if cursorX + (word.width * fontSize) > w and cursorX ~= 0 then
      cursorY = cursorY + lineSpacing + fontHeight  * fontSize
      cursorX = 0

      if utils.includes(consumable, word.text) then
        consume = true
      end
    end


    if not consume then
      for i = 1, #word.text do
        local charCode = string.byte(word.text:sub(i, i))

        for ry = 1, #font[charCode] do
          for rx = 1, #font[charCode][ry] do
            if font[charCode][ry][rx] ~= 0 then
              if fontSize ~= 1 then
                gfx.fillRect(
                  cursorX + x + (rx - 1) * fontSize,
                  cursorY + y + (ry - 1) * fontSize,
                  fontSize, fontSize
                )
              else
                -- Might be faster who knows
                gfx.drawPixel(cursorX + rx + x - 1, cursorY + ry + y - 1)
              end
            end
          end
        end

        cursorX = cursorX + charSpacing + #font[charCode][1] * fontSize 
      end
    end
  end
end

-- event.register(event.TICK, function ()
--   gfx.drawLine(50+150, 50, 50+150, 300, 255, 0, 0)
--   drawText(font, "Eheheh! Ith worketh! (Kris Get The Banana) Meow meow meow meow!", 50, 50, 150)
-- end)

return textEngine
