
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
require "config"
require "cocos.init"
print = release_print



require "catol.BaseInit"
local function main()
    -- require("app.scenes.MainScene"):create()
    require("app.MyApp"):create():run()
end

-- local str = "bTnabcdes"
-- print(string.find(str,"btn"))
-- local a,b = print(string.find(str,"[bB][tT][nN]"))
-- print(string.len("str"))
-- print("onPress"..string.sub(str,4, string.len(str)))
-- -- print = s

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
