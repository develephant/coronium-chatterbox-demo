
local widget = require('widget')

local ui = {
  cx = display.contentCenterX,
  cy = display.contentCenterY,
  cw = display.actualContentWidth,
  ch = display.actualContentHeight
}

function ui.newText(txt, x, y, w, h, size)
  size = size or 18
  local fld = display.newText( txt, x, y, w, h, native.systemFont, size )
  fld:setFillColor( 1, 1, 1 )
  return fld
end

function ui.newButton(opts, x, y, w, h)

  local options = {}

  options.id = opts.id
  options.shape = 'rect'
  options.width = w
  options.height = h
  options.x = x
  options.y = y
  options.label = opts.label

  options.onPress = opts.onPress

  return widget.newButton( options )

end

function ui.newTextField(x, y, w, h, listener)
  local fld = native.newTextField(x, y, w, h)
  fld.size = 18

  if listener then
    fld:addEventListener("userInput", listener)
  end

  return fld
end

function ui.newTextBox(x, y, w, h)
  local fld = native.newTextBox(x, y, w, h)
  fld.isEditable = true
  fld.text = ''
  return fld
end

function ui.showAlert(txt, listener)
  return native.showAlert("Coronium ChatterBox", txt, {"OK"}, listener)
end

return ui