
local composer = require( "composer" )
local scene = composer.newScene()

local ui = require('ui.core')
local cb = require('plugin.chatterbox')

--#############################################################################
--# Coronium ChatterBox
local host_ip = '<chatterbox-ip>'
local debug_mode = true
--#############################################################################

local loginName, roomName, chat, users, userCnt, inputBox

local chat_buf = {}

--#############################################################################
--# Privates
--#############################################################################

local function _addChat(msg)
  if #chat_buf > 20 then
    table.remove(chat_buf)
  end
  table.insert(chat_buf, 1, msg)
  chat.text = table.concat(chat_buf, "\n")
end

local function _clearChat()
  chat_buf = {}
  chat.text = ""
end

local function _renderUsers(user_list)
  local client_list = {}
  for i=1, #user_list do 
    table.insert(client_list, user_list[i].name)
  end
  users.text = table.concat(client_list, "\n")
end

local function _sendMessage(msg)
  cb:sendMessage(msg)
end

local function _disconnect()
  cb:disconnect()
end

local function _joinRoom(room_name)
  _clearChat()
  cb:joinRoom(room_name)
end

local function _changeName(new_name)
  cb:changeName(new_name)
end

--#############################################################################
--# Events
--#############################################################################

local function onConnect()
  print('=> Connected')
end

local function onJoined( evt )
  roomName.text = "Room: "..evt.data.room
  _addChat(evt.data.name.." has joined")
end

local function onLeft( evt )
  _addChat(evt.data.name.." has left")
end

local function onClientList( evt )
  userCnt.text = "Clients: "..evt.data.cnt
  _renderUsers(evt.data.clients)
end

local function onNameChange( evt )
  _addChat(evt.data.old_name.." is now "..evt.data.name)
  if cb:getId() == evt.data.id then
    loginName.text = "Name: "..evt.data.name
  end
end

local function onMessage( evt )
  _addChat(evt.data.name..": "..evt.data.msg)
end

local function onClosed()
  _renderUsers({})
  userCnt.text = "Clients: 0"
  roomName.text = "Room: ..."
  _addChat("Disconnected")
end 

local function onError( evt )
  print('Client Error: '..evt.error)
end

cb.events:addEventListener('OnConnect', onConnect)
cb.events:addEventListener('OnJoined', onJoined)
cb.events:addEventListener('OnLeft', onLeft)
cb.events:addEventListener('OnClientList', onClientList)
cb.events:addEventListener('OnNameChange', onNameChange)
cb.events:addEventListener('OnMessage', onMessage)
cb.events:addEventListener('OnClosed', onClosed)
cb.events:addEventListener('OnError', onError)

--#############################################################################
--# Composer
--#############################################################################

function scene:create( event )
  local grp = self.view
  
  --username
  loginName = ui.newText('Name: '..composer.getVariable("loginName"), 140, 100, 200, 24)
  grp:insert(loginName)

  --room
  roomName = ui.newText('Room: ...', 360, 100, 200, 24)
  grp:insert(roomName)

  --clients
  userCnt = ui.newText('Clients: 0', 860, 108, 200, 24)
  grp:insert(userCnt)

  --chat msgs
  chat = ui.newText("Welcome to Coronium CS", 320, 540, 560, 800)
  grp:insert(chat)

  --users
  users = ui.newText("Users!", 960, 540, 400, 800)
  grp:insert(users)

  --input
  inputBox = ui.newTextField(ui.cw*.5, 620, ui.cw-80, 32)
  grp:insert(inputBox)

  --buttons
  local function onButtonPress(evt)
    local t = evt.target.id

    if t == 'disconnect' then
      _disconnect()
    else
      if inputBox.text == '' then 
        ui.showAlert("Value missing for "..t..". Please enter a value in the input box.", function(evt)
          return
        end)
      else
        if t == 'send-msg' then
          _sendMessage(inputBox.text)
        elseif t == 'change-room' then
          _joinRoom(inputBox.text)
        elseif t == 'change-name' then
          _changeName(inputBox.text)
        end

        inputBox.text = ""
      end
    end
  end

  grp:insert(ui.newButton({label="Send Msg",id="send-msg", onPress=onButtonPress}, 934, 680, 100, 40))
  grp:insert(ui.newButton({label="Change Room",id="change-room", onPress=onButtonPress}, 110, 680, 140, 40))
  grp:insert(ui.newButton({label="Change Name",id="change-name", onPress=onButtonPress}, 280, 680, 140, 40))
  grp:insert(ui.newButton({label="Disconnect",id="disconnect", onPress=onButtonPress}, 500, 680, 140, 40))

end

function scene:show( event )
 
  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "did" ) then

    --#############################################################################
    --# Coronium ChatterBox
    cb:connect({
      host = host_ip, 
      name = composer.getVariable("loginName"),
      debug = debug_mode
    })
    --#############################################################################

  end
end

function scene:destroy( event )
  local sceneGroup = self.view
  _disconnect()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
 
return scene