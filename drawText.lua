---@param font { string: integer[][] }
---@param text string
---@param x integer
---@param y integer
---@param w integer
---@param lineSpacing integer?
---@param charSpacing integer?
function drawText(font, text, x, y, w, lineSpacing, charSpacing) 
  lineSpacing = lineSpacing or 4
  charSpacing = charSpacing or 1

  local breakOn = {" ", "-"}
  local consumable = {" "}

  ---@type { text: string, width: integer }[]
  local words = {}
  local wordBuffer = ""

  for i = 1, #text do
    local char = text:sub(i, i)

    for _, breakChar in ipairs(breakOn) do
      if char == breakChar or i == #text then
        if #wordBuffer > 0 then
          table.insert(words, { text = wordBuffer })
          wordBuffer = ""
        end

        table.insert(words, { text = char })
        goto continue
      end
    end

    wordBuffer = wordBuffer .. char
    ::continue::
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

    if cursorX + word.width > w and cursorX ~= 0 then
      cursorY = cursorY + fontHeight + lineSpacing
      cursorX = 0

      for _, consumableChar in ipairs(consumable) do
        if consumableChar == word.text then
          consume = true
          break
        end
      end
    end


    if not consume then
      for i = 1, #word.text do
        local charCode = string.byte(word.text:sub(i, i))

        for ry = 1, #font[charCode] do
          for rx = 1, #font[charCode][ry] do
            if font[charCode][ry][rx] ~= 0 then
              gfx.drawPixel(cursorX + rx + x - 1, cursorY + ry + y - 1)
            end
          end
        end

        cursorX = cursorX + #font[charCode][1] + charSpacing
      end
    end
  end
end

-- event.register(event.TICK, function ()
--   gfx.drawLine(50+150, 50, 50+150, 300, 255, 0, 0)
--   drawText(font, "Eheheh! Ith worketh! (Kris Get The Banana) Meow meow meow meow!", 50, 50, 150)
-- end)
