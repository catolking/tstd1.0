
local ViewBase = class("ViewBase", cc.Node)

function ViewBase:ctor(app, name)


    -- cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1920, 900, cc.ResolutionPolicy.FIXED_WIDTH)
    self:enableNodeEvents()
    self.app_ = app
    self.name_ = name

    -- check CSB resource file
    local res = rawget(self.class, "RESOURCE_FILENAME")
    if res then
        self:createResoueceNode(res)
    end

    self:initNodeName()






    


    
    -- local ui      = self.activePanel -- 得到activePanel节点
    -- local size    = cc.Director:getInstance():getVisibleSize() -- 屏幕分辨率大小
    -- local origin  = cc.Director:getInstance():getVisibleOrigin() -- 从画布的某个点显示

    -- -- 如果origin.x不等于0，表示是左右是被裁过的，把activePanel的x位置设置到屏幕里的0的位置
    -- if origin.x ~= 0 then
    --   ui:setPositionX(ui:getPositionX() + origin.x)
    -- end

    -- -- y的设置理解同上，上下被裁过的
    -- if origin.y ~= 0 then
    --   ui:setPositionY(ui:getPositionY() + origin.y)
    -- end

    -- -- 通过上面两个判断设置，ui在显示起始位置被固定好了，接下来设置ui的大小等于屏幕的大小，就大功告成了
    -- ui:setContentSize(size)


    local binding = rawget(self.class, "RESOURCE_BINDING")
    if res and binding then
        self:createResoueceBinding(binding)
    end

    if self.onCreate then self:onCreate() end
end

function ViewBase:getApp()
    return self.app_
end

function ViewBase:getName()
    return self.name_
end

function ViewBase:getResourceNode()
    return self.resourceNode_
end

function ViewBase:createResoueceNode(resourceFilename)

    if self.resourceNode_ then
        self.resourceNode_:removeSelf()
        self.resourceNode_ = nil
    end
    self.resourceNode_ = cc.CSLoader:createNode(resourceFilename)

     print("self.resourceNode_.node", self.resourceNode_.node)
    print("self.resourceNode_", self.resourceNode_.setContentSize)
    -- self.resourceNode_.setContentSize(_GLOBAL_W_, _GLOBAL_H_)
    dump(_GLOBAL_SIZE_, "sdsdsd")
    -- var root = ccs.load(res.MainScene_json); 
    -- root.node.setContentSize(cc.winSize); 
    -- ccui.helper.doLayout(root.node); 
    -- this.addChild(root.node); 



        -- -- 如果origin.x不等于0，表示是左右是被裁过的，把activePanel的x位置设置到屏幕里的0的位置
        -- if origin.x ~= 0 then
        --   ui:setPositionX(ui:getPositionX() + origin.x)
        -- end

        -- -- y的设置理解同上，上下被裁过的
        -- if origin.y ~= 0 then
        --   ui:setPositionY(ui:getPositionY() + origin.y)
        -- end

        -- -- 通过上面两个判断设置，ui在显示起始位置被固定好了，接下来设置ui的大小等于屏幕的大小，就大功告成了
        -- ui:setContentSize(size)




    -- self.resourceNode_ = cc.CSLoader:createNode("MainScene.csb")
    self:addChild(self.resourceNode_)
    self.resourceNode_:setContentSize(cc.size(display.width,display.height))
    ccui.Helper:doLayout(self.resourceNode_)



    assert(self.resourceNode_, string.format("ViewBase:createResoueceNode() - load resouce node from file \"%s\" failed", resourceFilename))
    -- self:addChild(self.resourceNode_)
end

function ViewBase:createResoueceBinding(binding)
    assert(self.resourceNode_, "ViewBase:createResoueceBinding() - not load resource node")
    for nodeName, nodeBinding in pairs(binding) do
        local node = self.resourceNode_:getChildByName(nodeName)
        if nodeBinding.varname then
            self[nodeBinding.varname] = node
        end
        for _, event in ipairs(nodeBinding.events or {}) do
            if event.event == "touch" then
                node:onTouch(handler(self, self[event.method]))
            end
        end
    end
end

function ViewBase:showWithScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_)
    scene:addChild(self)
    display.runScene(scene, transition, time, more)
    return self
end

function ViewBase:initNodeName()
    print("ViewBase:initNodeName()", self.resourceNode_)
    self.rootNode = self.resourceNode_
    local bufItem = nil
    local strName = ""
    local queue = {}
    table.insert(queue, self.rootNode)


    local bind_ = function(nodeName)    -- 根据控件名进行绑定
        local nNum = string.find(nodeName,"[bB][tT][nN]")   -- 查找btn
        if nNum ~= nil and nNum == 1 then
            local nLen = string.len(nodeName) 
            if nLen > 3 then
                local node = self[nodeName]
                if node:isTouchEnabled() == true then       -- 是否设定为可 交互性
                    node:onTouch(function(event) 
                        -- handler(self, self["onPress"..string.sub(nodeName,4, string.len(nodeName))])
                        if event.name == "began" then
                            self["onPress"..string.sub(nodeName,4, string.len(nodeName))](self, event)

                        end
                    end)
                end
            end
        end
    end

    -- function LoseLayer:createResoueceBinding(binding)
    --     for _, nodeBinding in pairs(binding) do

    --         for k,v in pairs(nodeBinding.items) do
    --                 print(k,v)
    --             end

    --         if nodeBinding.items then
    --             for _,nodeName in ipairs(nodeBinding.items) do
    --                 print(nodeName)
    --                 local node = self[nodeName]
    --                 if node then
    --                     for _, event in ipairs(nodeBinding.events or {}) do

    --                         if event.event == "touch" then
    --                             node:onTouch(handler(self, self[event.method]))
    --                         end
    --                     end
    --                 end
    --             end
    --         end
    --     end
    -- end
    -- 层次遍历 UI树 并将控件名称绑定到 self 中
    while #queue > 0 do
        bufItem = queue[1]
        
        table.remove(queue,1)
        for _, childItem in ipairs(bufItem:getChildren()) do
            strName = childItem:getName()
            print("strName",strName)
            self[strName] = self[strName] or childItem
            bind_(strName)
            table.insert(queue, childItem)
        end
    end
end

return ViewBase
