-- //////////////
-- Òþ²Ø¶Ô»°¿ò
-- by kong
-- //////////

HideScene=class(PGSceneBase)

function HideScene:ctor()

end

function HideScene:fini()

end

function HideScene:update()
	am_scene_update()
end

function HideScene:render()
	local i=1
	for i=1,AM_SCENE_BG_MAX do
		am_scene.bg[i]:render()
	end
	for i=1,AM_SCENE_FG_MAX do
		if i~=MSGBOX_NUM then
			am_scene.fg[i]:render()
		end
	end
 	for i=1,AM_SCENE_ANI_MAX do
		am_scene.ani[i]:update()
		am_scene.ani[i]:render()
	end   
	for i=1,AM_SCENE_FG_MAX do
		--am_scene.texfg[i]:render()
	end
	--text_layer_render()
	am_ramus_render()
end

function HideScene:KeyDown(key)
	if HIDEMODE == 1 then
		if key==PSP_BUTTON_CROSS then
			drawevent()
			playfile(DEFAULT_SOUND,4)
		end
	end
end

function HideScene:KeyUp(key)
	if HIDEMODE == 2 then
		if key==PSP_BUTTON_CROSS then
			drawevent()
			playfile(DEFAULT_SOUND,4)
		end
	end
end

function HideScene:TouchEnded(id,dx,dy,prev_dx,prev_dy,tapCount)
	if HIDEMODE == 1 then
		self:KeyDown(PSP_BUTTON_CROSS)
	elseif HIDEMODE == 2 then
		self:KeyUp(PSP_BUTTON_CROSS)
	end
end

--=========================================

function drawhide()
	if scene then scene:fini() end
	scene = HideScene.new()
	scene:init()
	collectgarbage("collect")
end
