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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fox_mask")
    inst.AnimState:SetBuild("fox_mask")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable")
    
    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "fox_mask"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fox_mask.xml"
    inst.components.inventoryitem.keepondeath = true

    MakeHauntableLaunch(inst)
    -- inst:AddComponent("spellcaster")
	-- inst.components.spellcaster:SetSpellFn(createlight)
    -- inst.components.spellcaster.canuseonpoint = true
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("common/inventory/fox_mask", fn, assets, prefabs)