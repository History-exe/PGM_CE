-- //////////////
-- HistoryScene
-- //////////

HistoryScene=class(PGSceneBase)

function HistoryScene:ctor()
	self.mode = 0
	self.width = DIALOG_FONT_WIDTH * (HISTORY_LINELEN/2)
	self.height = HISTORY_SETP_DY * HISTORY_LINEMAX
	
	self.bg = {
		file=false,
		dx=0,dy=0,
	}
	self.history = {
		name={},
		script={},
		voice={},
		dx={},dy={},
		count=0,	--当前页
		temp=0,		--最大值
	}
	self.slider = {
		bg=false,
		dx=0,dy=0,
		icon=false,
		x1=0,y1=0,
		length=0,
		buf=0,
		ispress=false,
	}
	self.select = {
		icon = false,
		icon2 = false,
		dx=0,dy=0,
		index=0,	--列表选中项
		count=0,	--当前选中项
		alpha=0,
		alphaV=5,
	}
	self.voice = {
		icon = false,
		dx=0,dy=0,
	}
	self.alpha = 0
end

function HistoryScene:init()
	self.mode = 1
	
	if HISTORY_BG then
		self.bg.file = CacheImageLoad(am_pack.res,HISTORY_BG,IMG_4444)
		self.bg.dx = 0
		self.bg.dy = 0
	end
	
	if LOG_SLIDER_ICON then
		self.slider.icon = CacheImageLoad(am_pack.res,LOG_SLIDER_ICON,IMG_4444)
		self.slider.length = self.height*HISTORY_SCREEN_COUNT -ImageGetH(self.slider.icon)
		self.slider.x1 = LOG_SLIDER_DX
		self.slider.y1 = LOG_SLIDER_DY + self.slider.length
	end
	
	local i
	for i=1,history.count do
		self.history.name[i] = history.name[i]
		self.history.script[i] = history.script[i]
		self.history.voice[i] = history.voice[i]
		self.history.dx[i] = HISTORY_TEXT_DX
		self.history.dy[i] = HISTORY_TEXT_DY + self.height*(HISTORY_SCREEN_COUNT-1) - self.height*(i-1)
		-- 后期处理
		if self.history.name[i] == nil then
			self.history.name[i] = ""
		end
		if self.history.voice[i] == nil then
			self.history.voice[i] = "system/nil.mp3"
		end
		-- 输出查看
		--print(i,self.history.voice[i],self.history.name[i],self.history.script[i])
	end
	font(HISTORY_FONT,HISTORY_FONTSIZE)
	fontwidth(HISTORY_FONTWIDTH,HISTORY_FONTHEIGHT)
	self.history.count = history.count
	self.history.temp = history.count
	for i=1,history.count do
		if not self.history.script[self.history.count-(i-1)] then
			texfg(i," ",0,0)
		elseif self.history.name[self.history.count-(i-1)] == "" then
			texfg(i,"[c=ffffff]" .. self.history.script[self.history.count-(i-1)] .. "[/c]",0,0,self.width,self.height)
		else
			texfg(i,"[c=ffffff]" .. self.history.name[self.history.count-(i-1)] .. "[n]" .. self.history.script[self.history.count-(i-1)] .. "[/c]",0,0,self.width,self.height)
		end
		texfgxy(i,self.history.dx[i],self.history.dy[i])
	end
	font(FONT,FONTSIZE)
	fontwidth(FONTWIDTH,FONTHEIGHT)

	self.select.index = 1
	self.select.count = 1
	self.select.icon = CacheImageLoad(am_pack.res,LOG_SELECT_ICON,IMG_4444)
	self.select.icon2 = CacheImageLoad(am_pack.res,LOG_UNSELECT_ICON,IMG_4444)
	--self.select.dx = self.history.dx[self.select.count] -5
	--self.select.dy = self.history.dy[self.select.count]
	
	self.voice.icon = CacheImageLoad(am_pack.res,LOG_VOICE_ICON,IMG_4444)
	self.voice.dx = 0
	self.voice.dy = 0
end

function HistoryScene:fini()
	if self.bg.file then
		ImageFree(self.bg.file)
		self.bg.file = nil
	end
	
	if self.slider.icon then
		ImageFree(self.slider.icon)
		self.slider.icon = nil
	end
	
	local i
	for i=1,history.count do
		texfgoff(i)
		texfgnull(i)
	end
	
	ImageFree(self.select.icon)
	self.select.icon = nil
	ImageFree(self.select.icon2)
	self.select.icon2 = nil
	ImageFree(self.voice.icon)
	self.voice.icon = nil
end

function HistoryScene:update()
	am_scene_update()

	--滑块坐标计算
	if self.history.temp > 1 then
		self.slider.buf = self.slider.y1 - ((self.select.index-1)/(self.history.temp-1))*self.slider.length
	end
	--当前选中项坐标计算
	self.select.dx = self.history.dx[self.select.count] -5
	self.select.dy = self.history.dy[self.select.count] -5
	
	if self.mode==1 then
		self.alpha = self.alpha + 35
		if self.alpha >= 255 then
			self.alpha = 255
			self.mode = 2
		end
		if self.bg.file then ImageSetMask(self.bg.file,MAKE_RGBA_4444(255,255,255,self.alpha)) end
		if self.slider.icon then ImageSetMask(self.slider.icon,MAKE_RGBA_4444(255,255,255,self.alpha)) end
		local i = 1
		for i=1,history.count do
			ImageSetMask(am_scene.texfg[i].image_p[am_scene.texfg[i].image_index+1],MAKE_RGBA_4444(255,255,255,self.alpha))
		end
		self.select.alpha = self.alpha
		ImageSetMask(self.select.icon,MAKE_RGBA_4444(255,255,255,self.select.alpha))
		ImageSetMask(self.select.icon2,MAKE_RGBA_4444(255,255,255,self.select.alpha))
		ImageSetMask(self.voice.icon,MAKE_RGBA_4444(255,255,255,self.alpha))
	elseif self.mode==2 then
		-- control
	elseif self.mode==3 then
		self.alpha = self.alpha - 35
		if self.alpha <= 0 then
			self.alpha = 0
			self.mode = 4
		end
		if self.bg.file then ImageSetMask(self.bg.file,MAKE_RGBA_4444(255,255,255,self.alpha)) end
		if self.slider.icon then ImageSetMask(self.slider.icon,MAKE_RGBA_4444(255,255,255,self.alpha)) end
		local i = 1
		for i=1,history.count do
			ImageSetMask(am_scene.texfg[i].image_p[am_scene.texfg[i].image_index+1],MAKE_RGBA_4444(255,255,255,self.alpha))
		end
		self.select.alpha = self.alpha
		ImageSetMask(self.select.icon,MAKE_RGBA_4444(255,255,255,self.select.alpha))
		ImageSetMask(self.select.icon2,MAKE_RGBA_4444(255,255,255,self.select.alpha))
		ImageSetMask(self.voice.icon,MAKE_RGBA_4444(255,255,255,self.alpha))
	end

end

function HistoryScene:render()
	local i
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

	for i=HISTORY_COUNT+1,AM_SCENE_FG_MAX do
		--am_scene.texfg[i]:render()
	end
	--text_layer_render()
	am_ramus_render()
	
	if self.bg.file then ImageToScreen(self.bg.file,self.bg.dx,self.bg.dy) end
	if self.history.temp > 1 then
		if self.slider.icon then ImageToScreen(self.slider.icon,self.slider.x1,self.slider.buf) end
	end
	ImageToScreen(self.select.icon,self.select.dx,self.select.dy)
	for i=1,HISTORY_SCREEN_COUNT do
		if not self.history.dx[i] then break end
		if i~=self.select.count then
			ImageToScreen(self.select.icon2,self.history.dx[i]-5,self.history.dy[i]-5)
		end
	end
	for i=1,HISTORY_SCREEN_COUNT do
		if not self.history.dx[i] then break end
		if self.history.voice[self.history.count-(i-1)] ~= "system/nil.mp3" then
			ImageToScreen(self.voice.icon,self.history.dx[i]+DIALOG_FONT_WIDTH*4,self.history.dy[i])
		end
	end
	
	for i=1,history.count do
		texfgoff(i)
	end
	for i=1,HISTORY_SCREEN_COUNT do
		texfgon(self.history.temp-self.history.count+i)
	end
	for i=1,history.count do
		am_scene.texfg[i]:render()
	end
	
end

function HistoryScene:idle()
	if self.mode==4 then
		drawevent()
		return
	end
end

--control
function HistoryScene:IconBack()
	self.select.count = self.select.count + 1
	if self.select.count > HISTORY_SCREEN_COUNT then
		self.select.count = HISTORY_SCREEN_COUNT
		self.history.count = self.history.count - 1
		if self.history.count < HISTORY_SCREEN_COUNT then
			self.history.count = self.history.count + 1
		end
	elseif self.select.count > self.history.temp then
		self.select.count = self.history.temp
	end
	self.select.index = self.select.index + 1
	if self.select.index > self.history.temp then
		self.select.index = self.history.temp
	end
	
	for i=1,history.count do
		local dx = self.history.dx[i]
		local dy = self.history.dy[i] + self.height*(self.history.temp-self.history.count)
		texfgxy(i,dx,dy)
	end
	--print(self.history.count,self.select.index)
end

function HistoryScene:IconNext()
	self.select.count = self.select.count - 1
	if self.select.count < 1 then
		self.select.count = 1
		self.history.count = self.history.count + 1
		if self.history.count > self.history.temp then
			self.history.count = self.history.temp
		end
	end
	self.select.index = self.select.index - 1
	if self.select.index < 1 then
		self.select.index = 1
	end
	
	for i=1,history.count do
		local dx = self.history.dx[i]
		local dy = self.history.dy[i] + self.height*(self.history.temp-self.history.count)
		texfgxy(i,dx,dy)
	end
	--print(self.history.count,self.select.index)
end

function HistoryScene:KeyDown(key)
	if self.mode~=2 then return end
	if key==PSP_BUTTON_UP then
		self:IconBack()
	elseif key==PSP_BUTTON_DOWN then
		self:IconNext()
	elseif key==PSP_BUTTON_LEFT_TRIGGER then
		if self.history.temp > HISTORY_SCREEN_COUNT then
			self.select.count = HISTORY_SCREEN_COUNT
			self.select.index = self.history.temp
			self.history.count = HISTORY_SCREEN_COUNT
		else
			self.select.count = self.history.temp
			self.select.index = self.history.temp
			self.history.count = self.history.temp
		end
		self:IconBack()
	elseif key==PSP_BUTTON_RIGHT_TRIGGER then
		self.select.count = 1
		self.select.index = 1
		self.history.count = self.history.temp
		self:IconNext()
	elseif key==PSP_BUTTON_CIRCLE then
		mp3unload(2)
		playfile(self.history.voice[self.history.temp-(self.select.index-1)],2)
		--print(self.history.voice[self.history.temp-(self.select.index-1)],self.history.temp-(self.select.index-1))
	elseif key==PSP_BUTTON_CROSS then
		mp3unload(2)
		self.mode = 3
	end
end

function HistoryScene:KeyUp(key)
	if self.mode~=2 then return end
	if key==PSP_BUTTON_UP then

	elseif key==PSP_BUTTON_DOWN then

	elseif key==PSP_BUTTON_LEFT_TRIGGER then

	elseif key==PSP_BUTTON_RIGHT_TRIGGER then

	elseif key==PSP_BUTTON_CIRCLE then

	elseif key==PSP_BUTTON_CROSS then

	end
end

function HistoryScene:TouchBegan(id,dx,dy,prev_dx,prev_dy,tapCount)
	if self.mode~=2 then return end
	if dx > self.slider.x1 and dx < self.slider.x1 + ImageGetW(self.slider.icon)
		and dy > self.slider.buf and dy < self.slider.buf + ImageGetH(self.slider.icon) then
		self.slider.ispress = true
		return
	end

end

function HistoryScene:TouchMoved(id,dx,dy,prev_dx,prev_dy,tapCount)
	if self.mode~=2 then return end
	if self.slider.ispress then
		if dy < self.slider.buf then
			self:IconBack()
		elseif dy > self.slider.buf + ImageGetH(self.slider.icon) then
			self:IconNext()
		end
		return
	end

end

function HistoryScene:TouchEnded(id,dx,dy,prev_dx,prev_dy,tapCount)
	if self.mode~=2 then return end
	if self.slider.ispress then
		self.slider.ispress = false
		return
	end

end

--=============================
function historybegin()
	history = {}
	history.name = {}
	history.script = {}
	history.voice = {}
	history.count = 1
end

function voicerecode(file)
	history.voice[history.count] = file
end

function namerecode(tx)
	history.name[history.count] = tx
end

function textrecode(tx)
	if not history.script[history.count] then
		history.script[history.count] = tx
	else
		history.script[history.count] = history.script[history.count] .. tx
	end
end

function countrecode()
	history.count = history.count + 1
	--历史记录上限
	if history.count > HISTORY_COUNT then
		history.name[1] = nil
		history.script[1] = nil
		history.voice[1] = nil
		for i=1,history.count do
			history.name[i] = history.name[i+1]
			history.script[i] = history.script[i+1]
			history.voice[i] = history.voice[i+1]
		end
		history.count = HISTORY_COUNT
	end
end

--/////////////////
--texfg的行字符数限制在TextLayer.lua第50行
function texfg_quad_create(font_p,color,str,w,h,font_width,font_height)
	local layer=DialogLayer.new()
	layer:init(0,0,w,h,IMG_4444)
	string_to_quad(font_p,color,str,layer.quad,0,2,font_width,font_height,HISTORY_LINELEN,HISTORY_SETP_DY*HISTORY_LINEMAX)
	local quad=layer.quad[1]
	layer=nil
	return quad
end

--===============================

function drawhistory()
	if scene then scene:fini() end
	if am_ramus then
		scene = PGRamusScene.new()
	else
		scene = HistoryScene.new()
	end
	scene:init()
	collectgarbage("collect")
end
