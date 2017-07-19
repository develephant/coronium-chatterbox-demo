
local composer = require( "composer" )
local scene = composer.newScene()

local ui = require('ui.core')
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local grp = self.view

    local loginGrp = display.newGroup()

    loginGrp:insert(ui.newText("Enter your name", 200, 200, 200, 24))

    local loginName = ui.newTextField(350, 200, 200, 24)
    loginGrp:insert(loginName)

    local function onButtonPress(evt)
      if loginName.text == '' then
        ui.showAlert("Name is missing!", function(evt)
          return
        end)
      else
        loginName:removeSelf()
        composer.setVariable("loginName", loginName.text)
        composer.gotoScene("scenes.chat")
      end
    end

    local loginBtn = ui.newButton({
      label = "Login",
      onPress = onButtonPress
    }, 516, 200, 100, 24)

    loginGrp:insert(loginBtn)
    
    grp:insert(loginGrp)

    loginGrp.x = 180
    loginGrp.y = 180

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene