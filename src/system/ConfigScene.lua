-- //////////////
-- 设置菜单
-- by kong
-- //////////

ConfigScene=class(PGSceneBase)

function ConfigScene:ctor()
	self.index = 1
	
        self.bg = CacheImageLoad(am_pack.res,CONFIG_BG,IMG_4444)
	
	self.bgm = ScrollBar.new(CONFIG_SLIDER_BG,CONFIG_SLIDER_ICON)
	self.bgm.dx = CONFIG_BGM_DX		--横坐标
	self.bgm.dy = CONFIG_BGM_DY		--纵坐标
	self.bgm.index = pub_value[128]         --当前刻度
	self.bgm.temp = CONFIG_LENMAX	--总刻度
        
        self.voice = ScrollBar.new(CONFIG_SLIDER_BG,CONFIG_SLIDER_ICON)
        self.voice.dx = CONFIG_CV_DX
        self.voice.dy = CONFIG_CV_DY
        self.voice.index = pub_value[127]
        self.voice.temp = CONFIG_LENMAX

        self.text = ScrollBar.new(CONFIG_SLIDER_BG,CONFIG_SLIDER_ICON)
        self.text.dx = CONFIG_TEXT_DX
        self.text.dy = CONFIG_TEXT_DY
        self.text.index = pub_value[126]
        self.text.temp = CONFIG_LENMAX
end

function ConfigScene:init()

end

function ConfigScene:fini()
	ImageFree(self.bg)
	self.bg = false

	self.bgm:fini()
	self.bgm=false
     
        self.voice:fini()
        self.voice=false
        
        self.text:fini()
        self.text=false
end

function ConfigScene:update()
	am_scene_update()
	self.bgm:update()
        self.voice:update()
        self.text:update()
end

function ConfigScene:render()
	am_scene_render()
	ImageToScreen(self.bg,0,0)
	self.bgm:render()
        self.voice:render()
        self.text:render()
end

function ConfigScene:idle()
	self.bgm.ispress = false
        self.voice.ispress = false
        self.text.ispress = false
	if self.index== 1 then
		self.bgm.ispress = true
	elseif self.index== 2 then
                self.voice.ispress = true
	elseif self.index== 3 then
                self.text.ispress = true
        end
	BGM_VOL = self.bgm.index/self.bgm.temp * 128
	  mp3volume(1,BGM_VOL)
        VOICE_VOL = self.voice.index/self.voice.temp * 128
          mp3volume(2,VOICE_VOL)
        DIALOG_SPEED = (1-self.text.index/self.text.temp) * 80
end


-- control

function ConfigScene:KeyDown(key)
	if key==PSP_BUTTON_UP then
		self.index = self.index - 1
		if self.index < 1 then
			self.index = 1
		end
	elseif key==PSP_BUTTON_DOWN then
		self.index = self.index + 1
		if self.index > 3 then
			self.index = 3
		end
	elseif key==PSP_BUTTON_LEFT then
		if self.index==1 then
			self.bgm.index = self.bgm.index - 1
			if self.bgm.index < 0 then
				self.bgm.index = 0
			end
		elseif self.index==2 then
                        self.voice.index = self.voice.index - 1
                        if self.voice.index < 0 then
                                self.voice.index = 0
                        end
		elseif self.index==3 then
                        self.text.index = self.text.index - 1
                        if self.text.index < 0 then
                                self.text.index = 0
                        end
                end
	elseif key==PSP_BUTTON_RIGHT then
		if self.index==1 then
			self.bgm.index = self.bgm.index + 1
			if self.bgm.index > self.bgm.temp then
				self.bgm.index = self.bgm.temp
			end
                elseif self.index==2 then 
                        self.voice.index = self.voice.index + 1
                        if self.voice.index > self.voice.temp then
                                self.voice.index = self.voice.temp
                        end
                elseif self.index==3 then 
                        self.text.index = self.text.index + 1
                        if self.text.index > self.text.temp then
                                self.text.index = self.text.temp
                        end
		end
	elseif key==PSP_BUTTON_CIRCLE then

	elseif key==PSP_BUTTON_CROSS then
		self:pub_value_save()
                drawevent()
	end
end

function ConfigScene:pub_value_save()
	pub_value[128] = self.bgm.index
	pub_value[127] = self.voice.index
	pub_value[126] = self.text.index
        amp_pubsave()
end

--===============
function pub_value_init()
	pub_value[128] = 5
	pub_value[127] = 5
	pub_value[126] = 5
        pub_value_load()
end

function pub_value_load()
	BGM_VOL = pub_value[128]/CONFIG_LENMAX * 128
	  mp3volume(1,BGM_VOL)
        VOICE_VOL = pub_value[127]/CONFIG_LENMAX * 128
          mp3volume(2,VOICE_VOL)
        SE_VOL=128
        DIALOG_SPEED = (1-pub_value[126]/CONFIG_LENMAX) * 80
end

-- ================================================

function drawconfig()
	if scene then scene:fini() end
	scene = ConfigScene.new()
	scene:init()
	collectgarbage("collect")
end
