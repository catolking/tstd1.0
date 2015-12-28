--
-- Author: Paul
-- Date: 2015-07-27 14:58:15
--


local Hero = class("Hero")

function  Hero:ctor(initParam)
	self:initData(initParam)
end

function Hero:initData(initParam)
	print("____src Param", initParam.id)
	self.srcData = initParam
	self.data = clone(initParam)
	-- 基础
	genParam(self, initParam)
	self.baseData = gLobbyLogic:baseHeroInfo()[initParam.id]
	self:initEquip()
	self.currentData = {}
end

function Hero:initEquip()
	-- print("Hero:initEquip()", self.baseData.name)
	dump(self.data.equips, "self.data.equips")
	self.equipList = {}
	if self.data.equips == nil or #self.data.equips < 1 then
	else
		for tag, equip in ipairs(self.data.equips) do
		 	if equip.id then
	 			self.equipList[tag] = gLobbyLogic:createModelItem(equip)
		 	end
		end
	end
	self:getEquipData()
end

function Hero:getIcon()
	return self.baseData.icon
end

function Hero:getEquipList()
	return self.data.equips
end

function Hero:getSrcEquipList()
	return self.srcData.equips
end

function Hero:useNewEquip(data, tag)
	print("Hero:useNewEquip(data, tag)")
	self.data = clone(self.srcData)
	self.equipList[tag] = nil
	self.equipList[tag] = gLobbyLogic:createModelItem(data)
	self.equipData = nil
	self.allDatas = nil
	dump(self.currentData, "self.currentData")


	for k,v in pairs(self.currentData) do
		self.currentData[k] = nil
	end


	dump(self.currentData, "self.currentData")
	print("Hero:useNewEquip(data, tag)")

end

function Hero:getCpmItemData(item, ItemIndex)
	print("Hero:getCpmItemData(item, ItemIndex)")
	local tmpCpmData = clone(self.srcData)
	tmpCpmData.equips[ItemIndex] = item
	local tmpHero = gLobbyLogic:createModelHero(tmpCpmData)
	print("ccccccccccccccccccccccccmmmmmmmmmmmmmmmpppppppppppppppp")


	-- dump(tmpHero, "tmpHero", 6)
	print("ccccccccccccccccccccccccmmmmmmmmmmmmmmmpppppppppppppppp")
	-- return {src = self:getAllDatas(), Hero:create(tmpCpmData):getAllDatas()}
	return {src = self:getAllDatas(), des = tmpHero:getAllDatas()}
end

function Hero:getEquipData()
	print("Hero:getEquipData()", self.equipData)
	if self.equipData == nil then
		print("Hero:getEquipData() ____init ")
		local tempData = {}
		print(", self.baseData.name", self.baseData.name)
		for tag, equip in pairs(self.equipList) do
			print("equip value:", tag, equip:getAttrib().att)
			tableAdd(tempData, equip:getAttrib())
		end
		self.equipData = tempData

	end

	return self.equipData
end

function Hero:getAllDatas()
	if self.allDatas == nil then
		local tmpDatas = {}
		tmpDatas["hp"]  = self:getCurrentHp()
		tmpDatas["att"] = self:getCurrentAtt()
		tmpDatas["def"] = self:getCurrentDef()
		tmpDatas["frc"] = self:getCurrentFrc()
		tmpDatas["cpt"] = self:getCurrentCpt()
		tmpDatas["spd"] = self:getCurrentSpd()
		tmpDatas["int"] = self:getCurrentInt()
		tmpDatas["maxHp"] = self:getMaxHp()
		tmpDatas["dck"] = self:getCurrentDck()
		tmpDatas["hit"] = self:getCurrentHit()
		tmpDatas["crt"] = self:getCurrentCrt()
		tmpDatas["skill"] = self:getCurrentSkill()
		tmpDatas["level"] = self.level
		self.allDatas = tmpDatas
	end 

	print("Hero:getAllDatas()", self.allDatas)

	

	
	return self.allDatas
end

function Hero:getTalent()
	return self.baseData.talent
end

function Hero:getName()
	return self.baseData.name
end



-- id,name,icon,type,hp,grHp,att,grAtt,def,grDef,frc,grFrc,cpt,grCpt,spd,grSpd,int,grInt,skill,ruse,lvl,subtype,desc

-- 闪避
function Hero:getCurrentDck()
	if self.currentData.dck == nil then
		self.currentData.dck = 50 + math.ceil(self.level * 1.5 + self:getCurrentDef() / 3)
	end
	return self.currentData.dck
end

-- 命中
function Hero:getCurrentHit()
	if self.currentData.hit == nil then
		self.currentData.hit = 50 + math.ceil(self.level * 3.5 + self:getCurrentAtt() / 3)
	end
	return self.currentData.hit
end

-- 暴击
function Hero:getCurrentCrt()
	if self.currentData.crt == nil then
		self.currentData.crt = 50 + math.ceil(self.level * 2 + self:getCurrentAtt() / 8)
	end
	return self.currentData.crt
end

-- 攻击
function Hero:getCurrentAtt()
	if self.currentData.att == nil then
		self.currentData.att = self:calcAttrib("att", "grAtt")
	end
	return self.currentData.att
end

-- 防御
function Hero:getCurrentDef()
	if self.currentData.def == nil then
		self.currentData.def = self:calcAttrib("def", "grDef")
	end
	return self.currentData.def
end

-- 勇武
function Hero:getCurrentFrc()
	if self.currentData.frc == nil then
		self.currentData.frc = self:calcAttrib("frc", "grFrc")
	end
	return self.currentData.frc
end

-- 统帅
function Hero:getCurrentCpt()
	if self.currentData.cpt == nil then
		self.currentData.cpt = self:calcAttrib("cpt", "grCpt")
	end
	return self.currentData.cpt
end

-- 速度
function Hero:getCurrentSpd()
	if self.currentData.spd == nil then
		self.currentData.spd = self:calcAttrib("spd", "grSpd")
	end
	return self.currentData.spd
end

-- 智力
function Hero:getCurrentInt()
	if self.currentData.int == nil then
		self.currentData.int = self:calcAttrib("int", "grInt")
	end
	return self.currentData.int
end

function Hero:calcAttrib(attribName, grAttribName)
	return math.ceil(self.baseData[attribName] + (self.level * self.baseData[grAttribName]) + (self:getEquipData()[attribName] or 0))
end

function Hero:getCurrentHp()
	return self.currentHp
end

function Hero:getLevel()
	return self.level
end

function Hero:getMaxHp()
	return math.ceil(self.baseData.hp + (self.level * self.baseData.grHp) + (self:getCurrentCpt() ^ 0.5) / 10 * self.level + (self:getEquipData().hp or 0))
end

function Hero:getHPPercent()
	return self:getCurrentHp() / self:getMaxHp()
end

function Hero:getCurrentSkill()

end


return Hero