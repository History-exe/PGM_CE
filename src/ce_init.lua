
-- ================================================================
-- game msg var
-- ================================================================
-- 如果想使用psp官方存档,GAME_NAME不得超过12个字符
GAME_NAME = "PGMCE"
GAME_VERSION = 1.0
GAME_MSG = "PocketGameMaker-ConvertedEdition-"
GAME_SAVELISTSIZE = 8
GAME_SAVEMODE = PGMPSP
CreatePGMSaveFolder()

DEFAULT_SOUND = "system/nil.wav"
CERTAIN_SOUND = "system/certain.wav"
CANCEL_SOUND = "system/cancel.wav"

-- ================================================================
-- 对话框设定
MSGBOX = "msgbox01.png"
MSGBOX_NUM = 10
MSGBOX_DX = 0
MSGBOX_DY = 272-116
-- 名字设定
MSGNAME_NUM = 32
MSGNAME_DX = MSGBOX_DX+65
MSGNAME_DY = MSGBOX_DY+33-DIALOG_FONT_HEIGHT
-- 对话文本设定
MSGTEXT_DX = MSGBOX_DX+35
MSGTEXT_DY = MSGBOX_DY+40
MSGTEXT_LINELEN = 50
MSGTEXT_LINEMAX = 3
-- 立绘参数设定
FG_CENTER_DX = 0
FG_CENTER_DY = 0
FG_LEFT_DX = -120
FG_LEFT_DY = 0
FG_RIGHT_DX = 120
FG_RIGHT_DY = 0
FG_MOST_LEFT_DX = -240
FG_MOST_LEFT_DY = 0
FG_MOST_RIGHT_DX = 240
FG_MOST_RIGHT_DY = 0
FG_BACK_DX = 0
FG_BACK_DY = 0
-- 效果过渡时间设定
BG_FADETIME = 800
FG_FADETIME = 600
MSGBOX_FADETIME = 300
QUAKE_FADETIME = 500
BGM_FADETIME = 800

-- ================================================================
-- font msg constant var
-- ================================================================
FONT = "fz.ttf"
FONTSIZE = 11
FONTCOLOR = MAKE_RGBA_4444(0,0,0,255)
FONTWIDTH = 16
FONTHEIGHT = 18
am_font_getinstance()

-- ================================================================
-- dialog module constant var
-- ================================================================
DIALOG_ICON = "win_wait_a.png"
DIALOG_ICON_SPEED = 50
DIALOG_ICON_DX = 410
DIALOG_ICON_DY = 258
DIALOG_ICON_SIZE = 22
DIALOG_AUTO_ICON = "auto_icon.png"
DIALOG_AUTO_ICON_DX = 0
DIALOG_AUTO_ICON_DY = 0
DIALOG_AUTO_ICON_TICK = 350
DIALOG_AUTO_TICK = 2000
DIALOG_SOUND = DEFAULT_SOUND

-- ================================================================
-- menu module constant var
-- ================================================================
MENU_BOX = "menu_box.png"
MENU_BOX_DX = 142
MENU_BOX_DY = -8
MENU_ICON = "hand_icon01.png"
MENU_ICON_DX = 170
MENU_ICON_DY = 78
MENU_ICON_STEP_DX = 0
MENU_ICON_STEP_DY = 26
MENU_BUTTON = {"menu_skip.png","menu_auto.png","menu_load.png","menu_save.png","menu_quit.png"}
MENU_BUTTON_DX = 210
MENU_BUTTON_DY = 80
MENU_BUTTON_STEP_DX = 0
MENU_BUTTON_STEP_DY = 26
MENU_BUTTON_COUNT = 5
MENU_SOUND = DEFAULT_SOUND
MENU_CONTROL_MODE = 2	-- 1左右控制、2上下控制

-- ================================================================
-- ramus module constant var
-- ================================================================
RAMUS_ICON = "hand_icon02.png"
RAMUS_ICON_DX = 120
RAMUS_ICON_DY = 74
RAMUS_ICON_STEP_DX = 0
RAMUS_ICON_STEP_DY = 35
RAMUS_BUTTON_BG = "ramus_bg.png"
RAMUS_BUTTON_BG_DX = 60
RAMUS_BUTTON_BG_DY = 60
RAMUS_BUTTON_DX = 94
RAMUS_BUTTON_DY = 68
RAMUS_BUTTON_STEP_DX = 0
RAMUS_BUTTON_STEP_DY = 35
RAMUS_BUTTON_ICON_MODE = 2
RAMUS_SOUND = DEFAULT_SOUND

-- ================================================================
-- history module constant var
-- ================================================================
--字体
HISTORY_FONT = "simkai.ttf"
HISTORY_FONTSIZE = 10
HISTORY_FONTWIDTH = 16-3
HISTORY_FONTHEIGHT = 18-3
--UI
HISTORY_BG = "psp_history.png"	--背景图（可缺省）
HISTORY_TEXT_DX = 62
HISTORY_TEXT_DY = 48 -2
HISTORY_SETP_DX = 0
HISTORY_SETP_DY = DIALOG_FONT_HEIGHT +5
HISTORY_LINELEN = DIALOG_LINELEN	-- 行字符数限制
HISTORY_LINEMAX = 3	-- 行数量限制
HISTORY_COUNT = 30	-- 总数量//范围：1~30
HISTORY_SCREEN_COUNT = 3	-- 同屏数量限制
HISTORY_SOUND = "system/nil.wav"
-- 当前选中项
LOG_SELECT_ICON = "历史回忆_0000s_0002_对话框（选中）.png"
LOG_UNSELECT_ICON = "历史回忆_0000s_0004_对话框.png"
LOG_VOICE_ICON = "历史回忆_0000s_0001_喇叭图标.png"
-- 滑块设定（可缺省）
LOG_SLIDER_BG = ""
LOG_SLIDER_ICON = "历史回忆_0000s_0000_下拉条.png"
LOG_SLIDER_DX = 435
LOG_SLIDER_DY = HISTORY_TEXT_DY -5

-- ================================================================
-- config module constant var
-- ================================================================
CONFIG_BG = "config.png"
CONFIG_SLIDER_BG = "bottom.png"
CONFIG_SLIDER_ICON = "self.png"
CONFIG_LENMAX = 9
CONFIG_BGM_DX = 167+15
CONFIG_BGM_DY = 69
CONFIG_CV_DX = CONFIG_BGM_DX
CONFIG_CV_DY = CONFIG_BGM_DY+34
CONFIG_TEXT_DX = CONFIG_BGM_DX
CONFIG_TEXT_DY = CONFIG_BGM_DY+34*2

-- ================================================================
-- CG module constant var
-- ================================================================
-- ui setting
CG_BG = "cgmode_shirohane.png"
CG_SELECT = "cgmode_select.png"
CG_DX = 28
CG_DY = 44
CG_STEP_DX = 108
CG_STEP_DY = 67
CG_LENMAX = 4
-- page setting
CG_PAGE = 1
CG_COUNT = {}
local i,j,k=1,1,1
for i=1,CG_PAGE do
	CG_COUNT[i] = 3*4	--每页多少个缩略图
	CG_COUNT[CG_PAGE] = 2	--指定某页多少个缩略图
end
-- button setting
CG_EXIT = "cgmode_exit.png"
CG_EXIT_DX = 67
CG_EXIT_DY = 272-12
CG_BACK = "cgmode_back.png"
CG_BACK_DX = 0
CG_BACK_DY = 272-12
CG_NEXT = "cgmode_next.png"
CG_NEXT_DX = 480-67
CG_NEXT_DY = 272-12
CG_HELP = "cgmode_help.png"
CG_HELP_DX = 480-201
CG_HELP_DY = 272-18
-- other setting （可缺省）
CG_BGM = ""

-- ================================================================
-- helpbox module constant var
-- ================================================================
HELP_BOX = "help.png"
HELP_BOX_DX = 0
HELP_BOX_DY = 0

-- ================================================================
-- 攻略用到的图片,引擎默认按L键呼出攻略
-- ================================================================
--[[
	攻略
]]--
strategy_img={
	"攻略1.png",
	"攻略2.png",
	"攻略3.png",
}

