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
            if char == breakChar then
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
            local char = word.text:sub(j, j)

            if font[char] == nil then
                error("Character '" .. char .. "' not defined in font")
            end

            width = width + #font[char][1]
        end

        words[i].width = width
    end

    -- No wonky variable size characters please
    local fontHeight = #font["a"]

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
                local char = word.text:sub(i, i)

                for ry = 1, #font[char] do
                    for rx = 1, #font[char][ry] do
                        if font[char][ry][rx] ~= 0 then
                            gfx.drawPixel(cursorX + rx + x - 1, cursorY + ry + y - 1)
                        end
                    end
                end

                cursorX = cursorX + #font[char][1] + charSpacing
            end
        end
    end
end

-- local font = {
--     ["a"] = {
--         {0,1,1,1,0},
--         {0,0,0,0,1},
--         {0,0,0,0,1},
--         {0,1,1,1,1},
--         {1,0,0,0,1},
--         {1,0,0,0,1},
--         {0,1,1,1,0},
--     },
--     ["b"] = {
--         {1,0,0,0},
--         {1,0,0,0},
--         {1,0,0,0},
--         {1,1,1,0},
--         {1,0,0,1},
--         {1,0,0,1},
--         {1,1,1,0},
--     },
--     ["E"] = {
--         {1,1,1,1,1,1,1,1},
--         {1,0,0,0,0,0,0,0},
--         {1,0,0,0,0,0,0,0},
--         {1,1,1,1,1,1,1,1},
--         {1,0,0,0,0,0,0,0},
--         {1,0,0,0,0,0,0,0},
--         {1,1,1,1,1,1,1,1},
--     },
--     ["-"] = {
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {1,1,1,1,1},
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0}
--     },
--     [" "] = {
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0},
--         {0,0,0,0,0}
--     },
--
-- }

-- event.register(event.TICK, function ()
--     gfx.drawLine(50+40, 50, 50+40, 300, 255, 0, 0)
--    drawText(font, "aabab ababba ababa   EaE   ababababaab abab ab   ababababababababababa-baba abab abab ab", 50, 50, 40) 
-- end)
