ANIBase=class(PGBase)

function ANIBase:ctor()
	self.dx = 0
	self.dy = 0
	self.display = false
	self.image = false
	self.anitick = 0
	self.aniindex = 1
	self.aniquad = {}
	self.lasttick = 0
	self.isend = 1
	self.index = 0	
	self.file = ""

	self.ani_count = 16
	self.ani_speed = 50
	self.ani_time = 1000
end

function ANIBase:init()
	self.dx = 0
	self.dy = 0
	self.display = false
	self.image = false
end

function ANIBase:fini()
	self.aniquad = nil
	self:unloadImage()
	self.file = false
end

function ANIBase:load(file)
	self:unloadImage()
	local image = CacheImageLoad(am_pack.res,file,IMG_8888)
	if event[255] == 0 then
		self.image = ImageClone(image)
	elseif event[255] == 1 then
		self.image = ImageClone(image,1)
	end
	ImageFree(image)
	self.file = file
end

function ANIBase:unloadImage()
	ImageFree(self.image)
	self.image = false
	self.aniquad = nil
end

function ANIBase:set(count,speed,time)
	self.ani_count = count	--对应眨眼图片，一张图上有几帧就除以几
	self.ani_speed = speed	--每50毫秒移动一帧
	self.ani_time = time	--每2000毫秒完成一次眨眼动作
	self.w = ImageGetW(self.image) / self.ani_count
	self.h = ImageGetH(self.image)
	self.aniquad = {}
	for i = 1,self.ani_count do
		self.aniquad[i] = (i-1)*self.w
	end
end

function ANIBase:update()
	if self.image then
		if self.isend == 1 then
			if TimerGetTicks(am_timer) - self.anitick > self.ani_speed then
				self.anitick = TimerGetTicks(am_timer)
				self.aniindex = self.aniindex + 1
				if self.aniindex > self.ani_count then 
					self.isend = 2
					self.aniindex = 1 
					self.lasttick =  TimerGetTicks(am_timer)
				end
			end
		elseif self.isend == 2 then
			if TimerGetTicks(am_timer) - self.lasttick > self.ani_time then
				self.anitick = TimerGetTicks(am_timer)
				self.isend = 1
			end
		end
	end
end

function ANIBase:render()
	if not self.display then return end
	self.index = self.aniquad[self.aniindex]
	if self.image then
		DrawImage(self.image,self.index,0,self.w,self.h,self.dx,self.dy,self.w,self.h)
	end
end

function ani(index,file)
	am_scene.ani[index]:load(file)
end

function aniset(index,count,speed,time)
	am_scene.ani[index]:set(count,speed,time)
end

function aninull(index)
	am_scene.ani[index]:fini()
	am_scene.ani[index]:init()
end

function anixy(index,dx,dy)
	am_scene.ani[index].dx = dx
	am_scene.ani[index].dy = dy
end

function anion(index)
	am_scene.ani[index].display = true
end

function anioff(index)
	am_scene.ani[index].display = false
end
--[[
function animation(index,file,count,speed,time,dx,dy)
	ani(index,file)
	aniset(index,count,speed,time)
	anixy(index,dx,dy)
end
]]--
