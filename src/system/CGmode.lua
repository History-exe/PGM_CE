-- /////////////////
-- CG鉴赏模式
-- by kong
-- ////////////

--[[
【按键说明】
↑↓←→：选择；
Ｌ/Ｒ键：翻页；
△键：无/上一张CG；
○键：显示CG/下一张CG；
Ｘ键：退出CG鉴赏/返回CG鉴赏；
]]--
--================================
CgmodeScene=class(PGSceneBase)

function CgmodeScene:ctor()
	self.mode = 0
	self.alpha = 0
	
	self.bg = CacheImageLoad(am_pack.res,CG_BG,IMG_8888)

	self.icon = CacheImageLoad(am_pack.res,CG_SELECT,IMG_4444)
	self.dx = CG_DX  --初始光标坐标x
	self.dy = CG_DY  --初始光标坐标y
	
	self.page = 1
	
	self.index = 1
	self.x1 = {}
	self.y1 = {}
	
	self.num = 1
	
	self.ispress = false
	
	self.thumb = {}
	
	self.exit = false
	self.back = false
	self.next = false
	
	self.help_count = 0
end

function CgmodeScene:init()
	self.mode = 1
	
	self:count_update()
	if CG_BGM then
		playfile(CG_BGM,1)
	end
	for i=1,CG_PAGE do
		j=1
		for j=1,CG_COUNT[i] do
			if CG_LIST[i][j][1] and
			pub_event[(i-1)*CG_COUNT[1]+j]>=1 then
				local file = "thumb_" .. CG_LIST[i][j][1]
				self.thumb[(i-1)*CG_COUNT[1]+j] = CacheImageLoad(am_pack.res,file,IMG_4444)
			end
		end
	end
	
	if CG_EXIT then
		self.exit = PGColorButton.new(am_pack.res,CG_EXIT)
		self.exit.dx = CG_EXIT_DX
		self.exit.dy = CG_EXIT_DY	
	end
	if CG_BACK then
		self.back = PGColorButton.new(am_pack.res,CG_BACK)
		self.back.dx = CG_BACK_DX
		self.back.dy = CG_BACK_DY
	end
	if CG_NEXT then
		self.next = PGColorButton.new(am_pack.res,CG_NEXT)
		self.next.dx = CG_NEXT_DX
		self.next.dy = CG_NEXT_DY
	end
	
	if CG_HELP then
		self.help = CacheImageLoad(am_pack.res,CG_HELP,IMG_4444)
		self.help_dx = CG_HELP_DX
		self.help_dy = CG_HELP_DY
	end
end

function CgmodeScene:fini()
	ImageFree(self.bg)
	self.bg = false
	
	ImageFree(self.icon)
	self.icon = false
	
	for i=1,CG_PAGE do
		j=1
		for j=1,CG_COUNT[i] do
			if self.thumb[(i-1)*CG_COUNT[1]+j] then
				ImageFree(self.thumb[(i-1)*CG_COUNT[1]+j])
				self.thumb[(i-1)*CG_COUNT[1]+j] = nil
			end
		end
	end
	self.thumb = false
	
	if self.exit then
		ImageFree(self.exit)
		self.exit = false
	end
	if self.back then
		ImageFree(self.back)
		self.back = false
	end
	if self.next then
		ImageFree(self.next)
		self.next = false
	end
	if self.help then
		ImageFree(self.help)
		self.help = false
	end

end

function CgmodeScene:count_update()
	self.len = 1
	self.line = 1
	for i=1,CG_COUNT[self.page] do
		self.x1[i] = CG_DX + (self.len-1)*CG_STEP_DX
		self.y1[i] = CG_DY + (self.line-1)*CG_STEP_DY
		-- 换行排列
		self.len = self.len + 1
		if self.len > CG_LENMAX then
			self.len = 1
			self.line = self.line + 1
		end
		--print(self.x1[i],self.y1[i])
	end
end

function CgmodeScene:update()
	am_scene_update()
	
	self.dx = self.x1[self.index]
	self.dy = self.y1[self.index]
	
	if self.mode==1 then
		self.alpha = self.alpha + 10
		if self.alpha >= 255 then
			self.alpha = 255
			self.mode = 2
		end
		ImageSetMask(self.bg,MAKE_RGBA_8888(255,255,255,self.alpha))
		ImageSetMask(self.icon,MAKE_RGBA_4444(255,255,255,self.alpha))
		for i=1,CG_PAGE do
			j=1
			for j=1,CG_COUNT[i] do
				if self.thumb[(i-1)*CG_COUNT[1]+j] then
					ImageSetMask(self.thumb[(i-1)*CG_COUNT[1]+j],MAKE_RGBA_4444(255,255,255,self.alpha))
				end
			end
		end
		if self.exit then ImageSetMask(self.exit.image_p,MAKE_RGBA_8888(255,255,255,self.alpha)) end
		if self.back then ImageSetMask(self.back.image_p,MAKE_RGBA_8888(255,255,255,self.alpha)) end
		if self.next then ImageSetMask(self.next.image_p,MAKE_RGBA_8888(255,255,255,self.alpha)) end
	elseif self.mode==2 then
		-- control
	elseif self.mode==3 then
		self.alpha = self.alpha - 10
		if self.alpha <= 0 then
			self.alpha = 0
			self.mode = 4
		end
		if self.back then ImageSetMask(self.back.image_p,MAKE_RGBA_8888(255,255,255,self.alpha)) end
		if self.next then ImageSetMask(self.next.image_p,MAKE_RGBA_8888(255,255,255,self.alpha)) end
		if self.exit then ImageSetMask(self.exit.image_p,MAKE_RGBA_8888(255,255,255,self.alpha)) end
		for i=1,CG_PAGE do
			j=1
			for j=1,CG_COUNT[i] do
				if self.thumb[(i-1)*CG_COUNT[1]+j] then
					ImageSetMask(self.thumb[(i-1)*CG_COUNT[1]+j],MAKE_RGBA_4444(255,255,255,self.alpha))
				end
			end
		end
		ImageSetMask(self.icon,MAKE_RGBA_4444(255,255,255,self.alpha))
		ImageSetMask(self.bg,MAKE_RGBA_8888(255,255,255,self.alpha))
	end
end

function CgmodeScene:render()
	for i=1,AM_SCENE_BG_MAX do
		am_scene.bg[i]:render()
	end
	for i=1,AM_SCENE_FG_MAX-3 do
		am_scene.fg[i]:render()
	end
	for i=1,AM_SCENE_ANI_MAX do
		am_scene.ani[i]:update()
		am_scene.ani[i]:render()
	end
	for i=1,AM_SCENE_FG_MAX do
		am_scene.texfg[i]:render()
	end
	text_layer_render()
	am_ramus_render()

	ImageToScreen(self.bg,0,0)

	if self.exit then self.exit:render() end
	if self.back then self.back:render() end
	if self.next then self.next:render() end
	
	for i=1,CG_COUNT[self.page] do
		if self.thumb[(self.page-1)*CG_COUNT[1]+i] then
			ImageToScreen(self.thumb[(self.page-1)*CG_COUNT[1]+i],self.x1[i],self.y1[i])
		end
	end
	ImageToScreen(self.icon,self.dx,self.dy)
	for i=30,32 do
		am_scene.fg[i]:render()
	end
	if am_scene.fg[31].image_p[am_scene.fg[31].image_index+1] then
		self.help_count = self.help_count + 2
		if self.help_count>=60 then
			ImageToScreen(self.help,self.help_dx,self.help_dy)
		end
	else
		self.help_count = 0
	end
end

function CgmodeScene:idle()
	if self.mode==4 then
		drawevent()
		return
	end
end

function CgmodeScene:KeyDown(key)
	if self.mode~=2 then return end
	if key==PSP_BUTTON_TRIANGLE then
		self.num = self.num - 2
		self:KeyDown(PSP_BUTTON_CIRCLE)
	elseif key==PSP_BUTTON_CIRCLE then
		local index,time = 31,500
		local file = CG_LIST[self.page][self.index][self.num]
		if CG_LIST[self.page][self.index][self.num] and
		pub_event[(self.page-1)*CG_COUNT[1]+self.index]>=self.num then
			if am_scene.fg[index].image_p[am_scene.fg[index].image_index+1] then
				fgmov(index+1,index) fgon(index+1)
				fgeff(index+1,2,time)
				_fg(index,file,0,0,IMG_8888)
			else
				_fg(index,file,1,time,IMG_8888)
			end
			fgxy(index,0,0)
			fgon(index)
			self.ispress = true
			self.num = self.num + 1
		else
			fgeff(index,2,time)
			self.ispress = false
			self.num = 1
		end
	elseif key==PSP_BUTTON_CROSS then
		local index,time = 31,500
		if self.ispress then
			fgeff(index,2,time)
			self.ispress = false
			self.num = 1
		else
			if CG_BGM then
				--mp3unload(1)
			end
			self.exit.ispress = true
			self.back.ispress = false
			self.next.ispress = false
			self.mode = 3
		end
	end
	
	if self.ispress then return end
	if key==PSP_BUTTON_UP then
		if self.index-CG_LENMAX < 1 then return end
		self.index = self.index - CG_LENMAX
		if self.index < 1 then
			self.index = 1
		end
	elseif key==PSP_BUTTON_DOWN then
		if self.index+CG_LENMAX > CG_COUNT[self.page] then return end
		self.index = self.index + CG_LENMAX
		if self.index > CG_COUNT[self.page] then
			self.index = CG_COUNT[self.page]
		end
	elseif key==PSP_BUTTON_LEFT then
		if (self.index-1)%CG_LENMAX == 0 then return end
		self.index = self.index - 1
		if self.index < 1 then
			self.index = 1
		end
	elseif key==PSP_BUTTON_RIGHT then
		if self.index%CG_LENMAX == 0 then return end
		self.index = self.index + 1
		if self.index > CG_COUNT[self.page] then
			self.index = CG_COUNT[self.page]
		end
	elseif key==PSP_BUTTON_LEFT_TRIGGER then
		self.page = self.page - 1
		if self.page < 1 then
			self.page = CG_PAGE
		end
		self.index = 1
		self:count_update()
		self.exit.ispress = false
		self.back.ispress = true
		self.next.ispress = false
	elseif key==PSP_BUTTON_RIGHT_TRIGGER then
		self.page = self.page + 1
		if self.page > CG_PAGE then
			self.page = 1
		end
		self.index = 1
		self:count_update()
		self.exit.ispress = false
		self.back.ispress = false
		self.next.ispress = true
	end
end

function CgmodeScene:KeyUp(key)
	if self.mode~=2 then return end
	if key==PSP_BUTTON_CROSS then
		self.exit.ispress = false
		self.back.ispress = false
		self.next.ispress = false
	elseif key==PSP_BUTTON_LEFT_TRIGGER then
		self:KeyUp(PSP_BUTTON_CROSS)
	elseif key==PSP_BUTTON_RIGHT_TRIGGER then
		self:KeyUp(PSP_BUTTON_CROSS)
	end
end

--=======================
function cg_global(file)
	local i,j,k=1,1,1
	for i=1,CG_PAGE do
		j,k=1,1
		for j=1,CG_COUNT[i] do
			k=1
			for k=1,10 do
				if CG_LIST[i][j][k]==file and
				pub_event[(i-1)*CG_COUNT[1]+j]<=k then
					pub_event[(i-1)*CG_COUNT[1]+j] = k
					--amp_pubsave()
				end
			end
		end
	end
end

--==========================

function CGmode()
	if scene then scene:fini() end
	scene = CgmodeScene.new()
	scene:init()
	collectgarbage("collect")
end