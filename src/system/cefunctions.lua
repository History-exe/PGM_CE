
--========================================
-- define Converted Edition functions
-- by kong
--========================================


--======================================================
--基础指令
--======================================================
function name(tx)
	if tx then
		namerecode(tx)
		texfg(MSGNAME_NUM,tx,0,0)
		texfgxy(MSGNAME_NUM,MSGNAME_DX,MSGNAME_DY)
		texfgon(MSGNAME_NUM)
	else
		texfgoff(MSGNAME_NUM)
		texfgnull(MSGNAME_NUM)
	end
end

function text(...)
	if not arg[2] then
		-- say(dialog)
		textrecode(arg[1])
		--name()
		say(arg[1])
	else
		-- say(name,dialog)
		textrecode(arg[2])
		name(arg[1])
		say(arg[2])
	end
end

function textcl()
	name()
	textclear()
	voicestop()
 	countrecode()
end

function msgboxon()
	local time = MSGBOX_FADETIME
	if speakmode()==speak_mode_skip then
		time = time/4
	end
	textlen(MSGTEXT_LINELEN)
	textline(MSGTEXT_LINEMAX)
	textxy(MSGTEXT_DX,MSGTEXT_DY)
	fgnull(MSGBOX_NUM)
	_fg(MSGBOX_NUM,MSGBOX,1,time,IMG_8888)
	fgxy(MSGBOX_NUM,MSGBOX_DX,MSGBOX_DY)
	fgon(MSGBOX_NUM)
	pause(time)
end

function msgboxoff()
	local time = MSGBOX_FADETIME
	if speakmode()==speak_mode_skip then
		time = time/4
	end
	--textcl()
	fgeff(MSGBOX_NUM,2,time)
	pause(time)
end

function wait(time,...)
	if arg[1] and arg[1]==CANSKIP then
		waittime(time)
	else
		pause(time)
	end
end

--======================================================
--图片指令
--======================================================
function bg(file,...)
	local index,num,time = 1,1,BG_FADETIME
	local dx,dy = 0,0
	if speakmode()==speak_mode_skip then
		time = time/4
	end
	cg_global(file)
	if arg[1] and not arg[2] then
		if type(arg[1])=="string" then
			tst(arg[1])
			num = 4
		end
	elseif arg[1] and arg[2] then
		if type(arg[1])=="number" and
			type(arg[2])=="number" then
			dx,dy = arg[1],arg[2]
		end
	end
	if num==4 then
		--mask
		_bg(index,file,4,time)
	elseif am_scene.bg[index].image_p[am_scene.bg[index].image_index+1] then
		--crossfade
		bgmov(index+1,index) bgon(index+1)
		_bg(index,file,0,0)
		bgeff(index+1,2,time)
	else
		_bg(index,file,num,time)
	end
	bgxy(index,dx,dy)
	bgon(index)
	for i=1,3 do
		if arg[i]==CANSKIP then 
			return 
		end
	end
	pause(time)
end

function fg(file,...)
	local index,num,time = 1,1,FG_FADETIME
	local dx,dy = FG_CENTER_DX,FG_CENTER_DY
	if speakmode()==speak_mode_skip then
		time = time/4
	end
	if arg[1] and not arg[2] then
		if arg[1]==LEFT then
			index = 2
			dx,dy = FG_LEFT_DX,FG_LEFT_DY
		elseif arg[1]==CENTER then
			index = 1
			dx,dy = FG_CENTER_DX,FG_CENTER_DY
		elseif arg[1]==RIGHT then
			index = 3
			dx,dy = FG_RIGHT_DX,FG_RIGHT_DY
		end
	elseif arg[1] and arg[2] then
		if type(arg[1])=="number" and
			type(arg[2])=="number" then
			dx,dy = arg[1],arg[2]
		end
	end
	if am_scene.fg[index].image_p[am_scene.fg[index].image_index+1] then
		fgmov(index+3,index) fgon(index+3)
		_fg(index,file,0,time,IMG_8888)
		fgeff(index+3,2,time/2)
	else
		_fg(index,file,num,time,IMG_8888)
	end
	fgxy(index,dx,dy)
	fgon(index)
	for i=1,3 do
		if arg[i]==CANSKIP then 
			return 
		end
	end
	pause(time)
end

function fgcl(...)
	local i,time = 1,FG_FADETIME
	if speakmode()==speak_mode_skip then
		time = time/4
	end
	if arg[1] then
		for i=1,3 do
			if arg[i] and type(arg[i])=="number" then
				if am_scene.fg[i].image_p[am_scene.fg[i].image_index+1] then
					fgeff(arg[i],2,time)
				end
			end
		end
	else
		for i=1,3 do
			if am_scene.fg[i].image_p[am_scene.fg[i].image_index+1] then
				fgeff(i,2,time)
			end
		end
	end
	--pause(time)
end

function fadetimereset(type,time)
	if type == "bg" then
		BG_FADETIME = time
	elseif type == "fg" then
		FG_FADETIME = time
	elseif type == "msgbox" then
		MSGBOX_FADETIME = time
	elseif type == "quake" then
		QUAKE_FADETIME = time
	elseif type == "bgm" then
		BGM_FADETIME = time
	end
end

--======================================================
--动画指令
--======================================================
function animation(index,file,count,speed,time,dx,dy)
	if speakmode()==speak_mode_skip then
		count = count/4
		speed = speed/4
		time = time/4
	end
	ani(index,file)
	aniset(index,count,speed,time)
	anixy(index,dx,dy)
	anion(index)
end

function animationcl(index)
	anioff(index)
	aninull(index)
end

--======================================================
--音频指令
--======================================================
--=bgm指令
function bgm(file)
	local index = 1
	local file = BGMPATH .. file
	if am_sound.mp3[1].name == PGM_RES_FOLDER .. file then return end
	mp3load(file,index)
	mp3play(index)
end

function bgmstop(...)
	local time = BGM_FADETIME
	if arg[1] then time = arg[1] end
	bgmfade(BGM_VOL,0,time)
end

--=voice指令
function voice(file)
	local index = 2
	local file = VOICEPATH .. file
	mp3unload(index)
	voicerecode(file)
	if index==2 and scene.EventScene and
		speakmode()==speak_mode_skip then
		return
	end
	mp3load(file,index)
	if index==2 then mp3playtimes(index,1) end
	mp3play(index)
end

function voicestop()
	local index = 2
	mp3unload(index)
end

function voicereplay()
	local index = 2
	if am_sound.mp3[index].name~="" then
		mp3replay(index)		
	else
		wavunload(4)
		playfile(CANCEL_SOUND,4)
	end
end


--=sound指令
function sound(file,...)
	local index = 1
	local file = SOUNDPATH .. file
	--快进模式，去音效//0-去音效；1-不去音效
	if SKIPMODE == 0 and
		speakmode()==speak_mode_skip and
		scene.EventScene then
		return
	end
	if arg[1]==LOOP then
		index = 1
		wavplaytimes(index,0)
	else
		if arg[1] then
			index = arg[1]
		end
		wavplaytimes(index,1)
	end
	wavload(file,index)
	wavplay(index)
end

function soundstop(...)
	local i = 1
	if not arg[1] then
		for i=1,3 do wavunload(i) end
	else
		for i=1,3 do
			if not arg[i] then break end
			wavunload(arg[i])
		end
	end
end

--======================================================
--视频指令
--======================================================
function video(file)
	local file = VIDEOPATH .. file
	if PGMPSP then pmplay(file) end
end

--======================================================
--字体指令
--======================================================
function font(file,size)
        if am_font then
                if am_font.pf then
                        FontDelete(am_font.pf)
                        am_font.pf = false
                end
                FONT_PATH = FONTPATH .. file
                FONT_SIZE = size
                am_font_getinstance()
        end
end

function fontcolor(r,g,b,a)
	FONT_COLOR = MAKE_RGBA_4444(r,g,b,a)
end

function fontwidth(width,height)
	DIALOG_FONT_WIDTH = width
	DIALOG_FONT_HEIGHT = height
end

function textlen(num)
	DIALOG_LINELEN = num
end

function textline(line)
	DIALOG_LINEMAX = line
end

--======================================================
--特殊效果指令
--======================================================
--=画面抖动效果
function quake(...)
	local time = QUAKE_FADETIME
	if arg[1] then time=arg[1] end
	if speakmode()==speak_mode_skip then
		time = time/4
	end
	bgeff(1,3,time)
	for i=1,3 do
		if am_scene.fg[i].image_p[am_scene.fg[i].image_index+1] then
			fgeff(i,3,time)
		end
	end
	pause(0.6*time)
end

--=画面褪色效果
function monocro(value)
	--//0-原色；1-去色
	event[255] = value
end

--======================================================
--存档回调（自定义）
--======================================================
function amp_save_callback()
	-- 存档前的函数回调
	amp_pubsave()
end

function amp_load_callback()
	-- 读档后的函数回调
end

--======================================================
--安卓端待机补丁（请忽略这个）
--======================================================
function PGMSleep()
	for i=1,2 do mp3pause(i) end
	for i=1,4 do wavpause(i) end
end

function PGMWakeup()
	for i=1,2 do mp3resume(i) end
	for i=1,4 do wavresume(i) end
end
