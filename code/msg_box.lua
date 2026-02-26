BOX_CORNER_X = 94
BOX_CENTER_X = 240
BOX_CORNER_Y = 50

if not msg_box_tex then msg_box_tex=image.load("assets/dialog_box.png") end

function split(str, sep) --> table[string]
    local parts = string.gmatch(str, "([^"..sep.."]+)")
    local res = {}
    for part in parts do
        table.insert(res, part)
    end
    return res
end

function sp_print(line, x, y, size, col) --> nil
    if x == nil then x = 0 end
    if y == nil then y = 0 end
    if col == nil then col = color.white end
    if size == nil then size = 1 end
    local parts = split(line, "::")
    local i
    for i=1,#parts do
        if i%2 == 1 then
            screen.print(x, y, parts[i], size, col)
            x += screen.textwidth(parts[i], size)
        else
            atlas:draw(parts[i], x, y)
            x += atlas[parts[i]].w
        end
    end
end

function sp_text_width(line, size) --> int
    if size == nil then size = 1 end
    local parts = split(line, "\n")
    local width = 0
    local part_width = 0
    local i
    for i=1,#parts do
        part_width = sp_text_line_width(parts[i], size)
        if part_width > width then
            width = part_width
        end
    end
    return width
end

function sp_text_line_width(line, size) --> int
    if size == nil then size = 1 end
    local parts = split(line, "::")
    local width = 0
    local i
    for i=1,#parts do
        if i%2 == 1 then
            width += screen.textwidth(parts[i], size)
        else
            width += atlas[parts[i]].w
        end
    end
    return width
end

function multiline_sp_print(text, x, y, size, col) --> nil
    local parts = split(text, "\\")
    local i
    for i=0,#parts-1 do
        sp_print(parts[i+1], x, y + math.floor(i*size*18), size, col)
    end
end

function big_box (title, text) --> nil
    while true do
        if game_sel_bg then game_sel_bg:blit(0,0) end
        if title then
            sp_print(title, 240-(sp_text_width(title)/2), 12, 1, color.black)
        end

        if text then
            multiline_sp_print(text, 20, 40, .6, color.black)
        end

        sp_print(TEXT.press_circle, BOX_CENTER_X-(sp_text_width(TEXT.press_circle, .6)/2), 240, .6, color.black)

        screen.flip()

        buttons.read()
        if buttons.circle then
            break
        end
    end
end

function msg_box (line1, line1_y, line2, line2_y, line3, line3_y) --> nil
    while true do
        if game_sel_bg then game_sel_bg:blit(0,0) end
        msg_box_tex:blit(BOX_CORNER_X, BOX_CORNER_Y)

        if line1 then
            sp_print(line1, BOX_CENTER_X-(sp_text_width(line1)/2), BOX_CORNER_Y+line1_y)
        end

        if line2 then
            sp_print(line2, BOX_CENTER_X-(sp_text_width(line2)/2), BOX_CORNER_Y+line2_y)
        end

        if line3 then
            sp_print(line2, BOX_CENTER_X-(sp_text_width(line3)/2), BOX_CORNER_Y+line3_y)
        end

        sp_print(TEXT.press_circle, BOX_CENTER_X-(sp_text_width(TEXT.press_circle, .6)/2), 197, .6)

        screen.flip()

        buttons.read()
        if buttons.circle then
            break
        end
    end
end

function confirm_msg (line1, line1_y, line2, line2_y, line3, line3_y) --> nil
    while true do
        if game_sel_bg then game_sel_bg:blit(0,0) end
        msg_box_tex:blit(BOX_CORNER_X, BOX_CORNER_Y)

        if line1 then
            sp_print(line1, BOX_CENTER_X-(sp_text_width(line1)/2), BOX_CORNER_Y+line1_y)
        end

        if line2 then
            sp_print(line2, BOX_CENTER_X-(sp_text_width(line2)/2), BOX_CORNER_Y+line2_y)
        end

        if line3 then
            sp_print(line2, BOX_CENTER_X-(sp_text_width(line3)/2), BOX_CORNER_Y+line3_y)
        end

        if circle_to_confirm then
            sp_print(" ::circle::"..TEXT.yes, 115, 180, .6)
            sp_print(" ::cross::"..TEXT.no, 115, 196, .6)
        else
            sp_print(" ::cross::"..TEXT.yes, 115, 180, .6)
            sp_print(" ::circle::"..TEXT.no, 115, 196, .6)
        end

        screen.flip()

        buttons.read()
        if (circle_to_confirm and buttons.cross) or (not circle_to_confirm and buttons.circle) then -- cancel button
            return false
        elseif (circle_to_confirm and buttons.circle) or (not circle_to_confirm and buttons.cross) then -- confirm button
            return true
        end
    end
end
