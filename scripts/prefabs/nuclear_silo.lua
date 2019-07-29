--***************************************************************
--核弹发射井，已废弃，但先留着做参考
--***********************************************************************
local assets = {
	Asset("ANIM", "anim/nuclear_silo.zip"),--------建筑的贴图文件
	Asset("ATLAS", "images/inventoryimages/nuclear_silo.xml"),
}

----------------------------------------------------------------------------------------------------------------------
--有关的预制物，但是还没用到过
local prefabs = {}
-- SetSharedLootTable( 'nuclear_silo',     --------------建筑被破坏后掉落的东西列表
-- {
--  {'crystal_item', 1.00},
-- 	{'crystal_item', 0.75},
-- 	{'crystal_item', 0.50},
-- })


-- local function OnAttacked(inst,attacker)
-- 	inst.AnimState:PlayAnimation("hit")
-- 	inst.AnimState:PushAnimation("idle")
-- 	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_pick_rock")
-- end 

-- local function PowerBoard(inst,rad,power)
-- 	--print(inst,"onpower board")
--     local x,y,z = inst:GetPosition():Get()
--     local ents = TheSim:FindEntities(x,y,z,rad,{"icey_power_building"},{"icey_power_board","INLIMBO"})
--     for k,v in pairs(ents) do 
--         v:PushEvent("powertrans",{fromer = inst,power = power})
--     end

-- end 

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddLight() --发光
    inst.entity:AddNetwork() --让所有人都能看到这个东西

    MakeObstaclePhysics(inst, 1) --建筑物理碰撞体积
	-- inst.MiniMapEntity:SetIcon("wharang_shrine.tex") --设置小地图标志

    inst.AnimState:SetBank("nuclear_silo")
    inst.AnimState:SetBuild("nuclear_silo")
    inst.AnimState:PlayAnimation("idle") --建筑的动画设置
	
	inst.AnimState:SetMultColour(141/255,224/255,255/255,1)
	inst.Transform:SetScale(2,2,2)--用于设置建筑的放大缩小
	
	--发光
	inst.Light:SetIntensity(0.7)
	inst.Light:SetRadius(5)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetColour(44/255,143/255,255/255)
	inst.Light:Enable(true)
	
	-- inst:AddTag("icey_tower") --添加一个小标签
	-- inst:AddTag("icey_power_board")
	-- inst:AddTag("icey_power_building")
	-- inst:AddTag("companion")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("health")--添加建筑生命值
    inst.components.health:SetMaxHealth(1000)
	
	inst:AddComponent("combat")

    inst:AddComponent("inspectable")
	inst.components.inspectable:SetDescription("蘑菇弹发射器？") --设置可检查组件
	
    MakeHauntableWork(inst)--被作祟时的函数，这里是空的
  
	-- inst:ListenForEvent("attacked", OnAttacked)
	-- inst:ListenForEvent("death", OnKilled)
	
    return inst
end

return Prefab("nuclear_silo", fn, assets,prefabs)