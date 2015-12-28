--
-- Author: Paul
-- Date: 2015-07-26 11:02:25
--
local BaseCtrller = class("BaseCtrller")

function BaseCtrller:ctor(pageName,moduleName,initParam)
    self.pageName = pageName;
    self.moduleName = moduleName;
    self.initParam = initParam;
    require("framework.api.EventProtocol").extend(self)
end

function BaseCtrller:run()
	
end

function BaseCtrller:removeAllEvent()
	if self.handlerPool ~=nil then
		for k,v in pairs(self.handlerPool) do
			self.logic:removeEventListener(k, v)
			-- removeEventListener(eventName, key)
		end
	end
end

return BaseCtrller;