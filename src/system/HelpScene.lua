-- //////////////
-- ²Ù×÷ËµÃ÷
-- by kong
-- //////////

HelpScene=class(PGSceneBase)

function HelpScene:ctor()
	self.helpbox = ImageLoad(am_pack.res,HELP_BOX,IMG_8888)
end

function HelpScene:fini()
	ImageFree(self.helpbox)
	self.helpbox = nil
end

function HelpScene:update()
	am_scene_update()
end

function HelpScene:render()
	am_scene_render()
	ImageToScreen(self.helpbox,HELP_BOX_DX,HELP_BOX_DY)
end

function HelpScene:KeyDown(key)
	if HELPMODE == 1 then
		if key==PSP_BUTTON_CROSS then
			drawevent()
			playfile(DEFAULT_SOUND,4)
		elseif key==PSP_BUTTON_SQUARE then
			self:KeyDown(PSP_BUTTON_CROSS)
		end
	end
end

function HelpScene:KeyUp(key)
	if HELPMODE == 2 then
		if key==PSP_BUTTON_SQUARE then
			drawevent()
			playfile(DEFAULT_SOUND,4)
		end
	end
end

function HelpScene:TouchEnded(id,dx,dy,prev_dx,prev_dy,tapCount)
	if HIDEMODE == 1 then
		self:KeyDown(PSP_BUTTON_CROSS)
	elseif HIDEMODE == 2 then
		self:KeyUp(PSP_BUTTON_CROSS)
	end
end


--=========================================

function drawhelp()
	if scene then scene:fini() end
	scene = HelpScene.new()
	scene:init()
	collectgarbage("collect")
end
