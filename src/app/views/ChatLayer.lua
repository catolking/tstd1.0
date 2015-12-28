--
-- Author: Paul
-- Date: 2015-07-17 10:47:26
--

local chatLayer = class("chatLayer",ccui.RichText)

local chatLineLimit = 40   -- 最大的行数
local chatDeleteNum = 15    -- 超过最大行数一次删掉的行数

function chatLayer:ctor(initParam)
    -- if initParam == nil or initParam.parent == nil then return end
    self.parent_ = initParam.parent
	local richText = self;
	
    self:setContentSize(cc.size(400,0))
    self.width__ = 400
    self.height__ = 200
    self.calcHeight = 5
    self.defaultColor = cc.c3b(255, 0, 255)
    self.nVDiff = 5
    self.itemList = {}
    self.colorType = {
        cc.c3b(255, 0, 0),
        cc.c3b(0, 255, 0),
        cc.c3b(0, 0, 255),
    }

    self:ignoreContentAdaptWithSize(false)
    self:setVerticalSpace(self.nVDiff)
    -- self:setAnchorPoint(cc.p(0.25, 0))
    self.parent_:setSwallowTouches(false)
    -- self.parent_:onTouch(function() print("22222") return true end ,true, false)
    -- self:setPosition(-185, 1200)
    self.parent_:addChild(self)
    richText:setLocalZOrder(10)
    self:setGlobalZOrder(10)

    self:initPos()
    return self
end

local nTestId = 0

function chatLayer:initPos()
    self:checkLimit()
    local nHeight = self.calcHeight or self.height__
    self.parent_:setInnerContainerSize(cc.size(420,nHeight))

    self:setPosition(215, nHeight)
    -- self.parent_:setOffset(cc.p(0,0))
    self.parent_:scrollToBottom(0.3, true)
end

function chatLayer:checkLimit()
    if #self.itemList > chatLineLimit then
        self:removeHead(chatDeleteNum, false);
    end
end

function chatLayer:testAdd()
    
    local re_next = {}

    local strTexts = {
        "[战斗] 1亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮",
        "[系统] 2静静静静静静静静静静静静静静静静",
        -- "[系统] 3王王王王王王王王王王王王王王王王",
        -- "[系统] 4玉玉玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 5玉玉玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 6玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 7玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 8玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 9玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 10玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 11玉玉玉玉玉玉玉玉玉玉玉玉",
        -- "[系统] 12玉玉玉玉玉玉玉玉玉玉玉玉",
    }

    -- self:addRichText("11")
    -- self:addRichText("22")

    for i,v in ipairs(strTexts) do
        -- if true then
        --     -- print("sizeeeeeee",)
        --     local nHeight = math.ceil(cc.LabelTTF:create(strTexts[i], display.DEFAULT_TTF_FONT, 20):getContentSize().width/self.width__)*20+12
        --     local mapSize = cc.size(self.width__,  nHeight); 
        --     local ttf =  cc.LabelTTF:create(strTexts[i], display.DEFAULT_TTF_FONT, 20, mapSize, cc.TEXT_ALIGNMENT_LEFT)
        --     ttf:setColor(cc.c3b(255 - 40* i, 40*i, 40*i)); 
        --     -- ttf:setPosition(cc.p(100,100))
        --     re_next[#re_next + 1] = ccui.RichElementCustomNode:create(12, cc.c3b(255, 255, 255), 255,ttf);
        -- else
        --     re_next[#re_next + 1] = ccui.RichElementText:create( i, cc.c3b(255, 255, 255), 100, strTexts[i], "Helvetica", 24 )
        -- end

        self:addText({text =  strText, type = (i -1) % 3 + 1})

        -- richText:pushBackElement(re_next[i]);
    end
end

function chatLayer:addText(initParam)
    if initParam == nil or initParam.text == nil then return end 
    
    local strText = initParam.text
    strText = strText..nTestId
    nTestId = nTestId + 1

    local nFontSize = initParam.size  or  20
    local nColor  = nil 

    if initParam.type == nil then
        nColor = initParam.color or self.defaultColor
    else
        nColor = self.colorType[initParam.type]
    end

    local nHeight = math.ceil(cc.LabelTTF:create(strText, display.DEFAULT_TTF_FONT, nFontSize):getContentSize().width/self.width__)*nFontSize + nFontSize/2
    local mapSize = cc.size(self.width__,  nHeight); 

    self.calcHeight = self.calcHeight + nHeight + self.nVDiff
    self.itemList[#self.itemList + 1] = {1, nHeight + self.nVDiff}


    local ttf =  cc.LabelTTF:create(strText, display.DEFAULT_TTF_FONT, nFontSize, mapSize, cc.TEXT_ALIGNMENT_LEFT)
    
    if initParam.opacity then
        ttf:setOpacity(initParam.opacity)
    end

    ttf:setColor(nColor); 
    self:pushBackElement(ccui.RichElementCustomNode:create(12, cc.c3b(255, 255, 255), 255,ttf));
    self:initPos()
end

function chatLayer:addNewLine()
    -- self.itemList[#self.itemList + 1] = 1
    local node = display.newNode()
    node:setContentSize(cc.size(self.width__, 0))
    self:pushBackElement(ccui.RichElementCustomNode:create(12, cc.c3b(255, 255, 255), 255, node));
    self.calcHeight = self.calcHeight + 3
    self:initPos()
end

function chatLayer:removeHead(nNum, isUpdate)
    if #self.itemList < 2 then return end
    nNum = nNum or 1
    if nNum > #self.itemList - 1 then
        nNum = #self.itemList - 1 
    end

    print(" #self.itemList",  self.itemList[1])
    for j=nNum, 1, -1 do
        for i=self.itemList[1][1], 1, -1 do
            self:removeElement(1)
        end
        self.calcHeight = self.calcHeight - self.itemList[1][2]
        table.remove(self.itemList, 1)
    end

    if isUpdate == nil or isUpdate == true then
        self:initPos()
    end
end

function chatLayer:addRichText(initParam)

    local items = initParam or {
        {
            text = "[战斗]",
            type = 1,
        }    ,
        {
            text = "恭喜获得",
            type = 2,
        }    ,
        {
            text = "地瓜",
            type = 3,
        }    ,
        {
            text = "一个"..nTestId,
            type = 2,
        }    ,
    }

    nTestId = nTestId + 1

    local strAllText = ""
    local nFontSize =  20

    local nItemCount = 0
    for k,v in pairs(items) do
        nItemCount = nItemCount + 1
        strAllText = strAllText ..  v.text
        self:pushBackElement(ccui.RichElementText:create(k, self.colorType[v.type], 255, v.text, "Helvetica",  nFontSize))
    end

    
    local nHeight = math.ceil(cc.LabelTTF:create(strAllText, display.DEFAULT_TTF_FONT, nFontSize):getContentSize().width/self.width__)*(nFontSize + 2.5) + nFontSize / 2 - 2.5
    print("____color__height", nHeight)

    self.calcHeight = self.calcHeight + nHeight

    self:addNewLine()
    self.itemList[#self.itemList + 1] = {nItemCount + 1, nHeight + 3}
end























function chatLayer:testChat()
      local strTexts = {
            "[系] 1亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮亮2体",
        "[系] 2静静静静静静静静静静静静静静静静静",
        "[系] 3王王王王王王王王王王王王王王王王王.",
        "[系] 4玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
        "[系] 5玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
        "[系] 6玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
        "[系] 7玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
        "[系] 8玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉玉.",
    }
end


return chatLayer