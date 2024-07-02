---@param font { string: boolean[][] }
---@param text string
---@param x integer
---@param y integer
---@param w integer
---@param lineSpacing integer?
function drawText(font, text, x, y, w, lineSpacing) 
    lineSpacing = lineSpacing or 4

    local breakOn = {" "}

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

            width = width + #font[char][0]
        end

        words[i].width = width
    end

    -- No wonky variable size characters please
    local fontHeight = #font["a"]

    local cursorX = 0
    local cursorY = 0

    for _, word in ipairs(words) do
        if cursorX + word.width > w and cursorX ~= 0 then
            cursorY = cursorY + fontHeight + lineSpacing
            cursorX = 0
        end

        for i = 1, #word.text do
            local char = word.text:sub(i, i)

            for y = 1, #font[char] do
                for x = 1, #font[char][y] do
                    if font[char][y][x] then
                       gfx.drawPixel(cursorX + x - 1, cursorY + y - 1)
                    end
                end
            end

            cursorX = cursorX + #font[char][0]
        end
    end
end
