--
-- Author: Paul
-- Date: 2015-07-27 16:32:29
--

local Item = class("Item")

-- id = 1001,
-- attrib = 
-- {
--		hp =10,
-- }

function  Item:ctor(initParam)
	self:initData(initParam)
end

function Item:initData(initParam)
	genParam(self, clone(initParam))
	genParam(self, gLobbyLogic:baseItemInfo()[self.id])
	-- dump(self, "initDataItem")
end

function Item:getAttrib()
	if self.RealAttrib == nil then
		local attribList = {}
		local attribNames = {"hp", "att", "def", "frc", "cpt", "spd", "int", "ruse"}

		for i,v in ipairs(attribNames) do
			if self[v] ~= nil then
				attribList[v] = self[v]
			end
		end

		tableAdd(attribList, self.attrib or {})
		self.RealAttrib = attribList
	end

	return self.RealAttrib or {}
end

function Item:getDesc()
	local strDesc = "名称:" .. self.name .. "\n"
	if self.type == 1 then 
		strDesc = strDesc .. "描述:" .. self.desc .. "\n"
	elseif self.type == 2 then 
		strDesc = strDesc .. "描述:" .. self.desc .. "\n"
	elseif self.type == 3 then 
		strDesc = strDesc .. "描述:" .. self.desc .. "\n"
	end
	print(strDesc)
	return strDesc
end

return Item