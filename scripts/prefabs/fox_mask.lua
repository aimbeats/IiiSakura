--***************************************************************
--狐狸面具
--***********************************************************************
local assets =
{
    Asset("ANIM", "anim/fox_mask.zip"),
    Asset("ANIM", "anim/swap_fox_mask.zip"), 
	Asset("ATLAS", "images/inventoryimages/fox_mask.xml"),
    Asset("IMAGE", "images/inventoryimages/fox_mask.tex"),
}

local prefabs = {}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "swap_fox_mask", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    inst.components.useableitem.inuse = false --移除右键卸下功能

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

local function state(inst)
	local owner = inst.components.inventoryitem.owner
	
	if inst:HasTag("mask_up") then
        inst:RemoveTag("mask_up")
        -- owner:PushEvent("unequip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		-- owner:PushEvent("equip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		-- owner.AnimState:OverrideSymbol("swap_object", "swap_yukariumbre", "swap") --切换面具样式
        inst.Light:Enable(false)
	else
        inst:AddTag("mask_up")
        -- owner:PushEvent("unequip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		-- owner:PushEvent("equip", {item=inst, eslot=EQUIPSLOTS.HANDS})
		-- owner.AnimState:OverrideSymbol("swap_object", "swap_yukariumbre", "swap") --切换面具样式
        inst.Light:Enable(true)
    end
    
    inst.components.useableitem.inuse = false --移除右键卸下功能
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork() --让所有人都能看到这个东西

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fox_mask")
    inst.AnimState:SetBuild("fox_mask")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable") -- 可检查
    
    inst:AddComponent("tradable") -- 可交易

    inst:AddComponent("inventoryitem") --库存？
    inst.components.inventoryitem.imagename = "fox_mask"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fox_mask.xml"
    inst.components.inventoryitem.keepondeath = true

    MakeHauntableLaunch(inst) --未知
    -- inst:AddComponent("spellcaster")
	-- inst.components.spellcaster:SetSpellFn(createlight)
    -- inst.components.spellcaster.canuseonpoint = true
    
    inst:AddComponent("equippable") --可装备
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("useableitem") --可以使用？
    inst.components.useableitem:SetOnUseFn( state ) --用于右键穿戴面具

    --创建光照
    local light = inst.entity:AddLight()
        light:SetFalloff(1)
        light:SetIntensity(.8)
        light:SetRadius(10)
        light:Enable(false)
        light:SetColour(0/255, 255/255, 0/255)
    return inst
end
STRINGS.NAMES.FOX_MASK = "狐狸面具"
STRINGS.RECIPE_DESC.FOX_MASK = "崩坏的面具" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOX_MASK = "有人管这个叫夜视仪 "
return Prefab("common/inventory/fox_mask", fn, assets, prefabs)