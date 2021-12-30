
-- ================================================================
-- dialog module constant var
-- ================================================================

--¡Á¼ü
function button_cross()
	drawhide()
end

--¡÷¼ü
function button_triangle()
	drawhistory()
end

--¡õ¼ü
function button_square()
	drawhelp()
end

--L¼ü
function button_left_trigger()
	drawauto()
	speakmode(speak_mode_auto)
end

--R¼ü
function button_right_trigger()
	drawskip()
	speakmode(speak_mode_skip)
end
--start¼ü
function button_start()
	if call_menu_flag then
		pub_value[129]=0x0
		drawmenu()
	end
end

--select¼ü
function button_select()
	drawconfig()
end


-- ================================================================
-- menu module constant var
-- ================================================================
function menu_callback()
	if menutest()==5 then
		allclear()
		stacknull()
		jump("am_start.ev")
		drawevent()
	elseif menutest()==1 then
		drawskip()
		speakmode(speak_mode_skip)
	elseif menutest()==2 then
		drawauto()
		speakmode(speak_mode_auto)
	elseif menutest()==3 then
		drawload()
	elseif menutest()==4 then
		drawsave()
	else drawevent() end
end
