local print = release_print
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false


-- for module display
CC_DESIGN_RESOLUTION = {
		width = 960,
		height = 540,


 -- EXACT_FIT = 0,
 -- NO_BORDER = 1,
 -- SHOW_ALL  = 2,
 -- FIXED_HEIGHT  = 3,
 -- FIXED_WIDTH  = 4,
 -- UNKNOWN  = 5,
		
		autoscale = "FIXED_WIDTH",
		callback = function(framesize)
		print (framesize)


				local ratio = framesize.width / framesize.height
				_GLOBAL_RATIO_ = ratio
				_GLOBAL_SIZE_ = cc.size(framesize.width , framesize.height)
				_GLOBAL_W_ = framesize.width;
				_GLOBAL_H_ = framesize.height;
				-- pDirector:setContentScaleFactor(ratio);
				if ratio <= 1.34 then
						-- iPad 768*1024(1536*2048) is 4:3 screen
						return {autoscale = "FIXED_WIDTH"}
				end
		end
}

-- 72 + 350  397 + 71




