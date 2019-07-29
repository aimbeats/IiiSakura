--***************************************************************
--梦魇
--***********************************************************************
local assets=
{ 
    Asset("ANIM", "anim/nightmare_dachi.zip"),--这个是放在地上的动画文件
    Asset("ANIM", "anim/swap_rock_dachi.zip"), --这个是手上动画
    Asset("ATLAS", "images/inventoryimages/nightmare_dachi.xml"),--物品栏图标的xml
}
--有关的预制物，但是还没用到过
local prefabs = {}

local function OnEquip(inst, owner) --当你把武器装备到手上时，会触发这个函数
    owner.AnimState:OverrideSymbol("swap_object", "swap_nightmare_dachi", "swap_nightmare_dachi")--这句话的含义是，用swap_myitem_build这个文件里的swap_myitem这个symbol，覆盖人物的swap_object这个symbol。swap_object，是人物身上的一个symbol，swap_myitem_build，则是我们之前准备好的，用于手持武器的build，swap_myitem就是存放手持武器的图片的文件夹的名字，mod tools自动把它输出为一个symbol。
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end

local function onattack(inst, attacker, target)
    --攻击时附带燃烧能力
	if target ~= nil and target.components.burnable ~= nil and math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability then
        target.components.burnable:Ignite(nil, attacker)
    end
end

-- local function OnTakeDamage(inst, damage_amount)
--     local owner = inst.components.inventoryitem.owner
--     if owner then
--         local sanity = owner.components.sanity
--         if sanity then
--             local unsaneness = damage_amount * TUNING.ARMOR_SANITY_DMG_AS_SANITY
--             sanity:DoDelta(-unsaneness, false)
--         end
--     end
-- end

local function fn()--这个函数就是实际创建物体的函数，上面所有定义到的函数，变量，都需要直接或者间接地在这个函数中使用，才能起作用
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork() --让所有人都能看到这个东西
     
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("nightmare_dachi")
    inst.AnimState:SetBuild("nightmare_dachi")
    inst.AnimState:PlayAnimation("idle")

	if not TheWorld.ismastersim then
        return inst
    end
 
    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")--添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
    inst.components.inventoryitem.imagename = "nightmare_dachi" --物品栏图片的名字
    inst.components.inventoryitem.atlasname = "images/inventoryimages/nightmare_dachi.xml"--物品栏图片的xml文件。为什么会有这么两句呢？在单个文件下也许会迷惑，但如果换成一个张大图就容易理解了。举个例子，游戏的操作界面,HUD，你可以在data\images下找到HUD.tex，用textool打开就会看到是一整张大的图片，包含了整个操作界面的所有图片，xml就是用来切割分块这张大的图片，并分别给它们重新命名的，新的命名就会被前面的imagename 使用。

    inst:AddComponent("equippable")--添加可装备组件，有了这个组件，你才能装备物品
    inst.components.equippable:SetOnEquip( OnEquip ) -- 设定物品在装备和卸下时执行的函数。在前面定义的两个函数是OnEquip，OnUnequip里，我们主要是围绕着改变人物外形设定了一些基本代码。 在装上的时候，会让人物的持物手显示出来，普通手隐藏，卸下时则反过来。需要注意的是，OnEquip，OnUnequip都是本地函数，要想让它们发挥作用，就必须要通过这里的组件接口来实现。
    inst.components.equippable:SetOnUnequip( OnUnequip )
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS --设定为手持方式
    inst.components.equippable.dapperness = -0.5
	
	inst:AddComponent("weapon")     
    inst.components.weapon:SetDamage(50)--设置武器的攻击力damage
    inst.components.weapon:SetOnAttack(onattack)
    inst.components.equippable.walkspeedmult = 1--设置持有时的移动速度
	
    inst:AddComponent("fueled")--添加燃料组件
    inst.components.fueled.fueltype = FUELTYPE.USAGE --可燃物类型，机翻是防毒面具什么鬼？
    inst.components.fueled:InitializeFuelLevel(180) --燃烧时间180s
    inst.components.fueled:SetDepletedFn(inst.Remove) --燃烧结束移除武器
	

    return inst
end
STRINGS.NAMES.NIGHTMARE_DACHI = "梦魇"
STRINGS.RECIPE_DESC.NIGHTMARE_DACHI = "最深处的黑暗" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NIGHTMARE_DACHI = "如果凛还在的话......"
return Prefab("common/inventory/nightmare_dachi", fn, assets, prefabs)--最后，返回这个实体到modmain里注册。Prefab这个函数，第一个参数只需要看最后一个/后面的部分，视为这个prefab的ID，fn则是上面定义的fn，是这个物品的创建函数，assets，对应上面的assets，主要是用于注册美术资源，如果你在这里注册了相应的美术资源，就不需要在modmain里再注册一次。prefabs，目前还未明确具体的作用。