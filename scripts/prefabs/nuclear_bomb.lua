local assets = {
	Asset("ANIM", "anim/nuclear_bomb.zip"),--这个是放在地上的动画文件
    Asset("ATLAS", "images/inventoryimages/nuclear_bomb.xml"),--物品栏图标的xml
    Asset("IMAGE", "images/inventoryimages/nuclear_bomb.tex"),--物品栏图标的图片
}

----------------------------------------------------------------------------------------------------------------------
local prefabs = {}

local function oneaten(inst, eater)

	if not eater:HasTag("player") then
		return
	end
	
    if eater then
		eater.components.talker:Say("唔！这......里有毒！", 3)
	end
	
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("nuclear_bomb")
	inst.AnimState:SetBuild("nuclear_bomb")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddComponent("edible") --可以吃
	inst.components.edible.healthvalue = -100
	inst.components.edible.sanityvalue = -100
	inst.components.edible.hungervalue = 300
	inst.components.edible.foodtype = "GENERIC"
    inst.components.edible:SetOnEatenFn(oneaten)

	inst:AddComponent("nuclear_bomb")--添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
	inst.components.inventoryitem.imagename = "nuclear_bomb" --物品栏图片的名字
	inst.components.inventoryitem.atlasname = "images/inventoryimages/nuclear_bomb.xml"--物品栏图片的xml文件。为什么会有这么两句呢？在单个文件下也许会迷惑，但如果换成一个张大图就容易理解了。举个例子，游戏的操作界面,HUD，你可以在data\images下找到HUD.tex，用textool打开就会看到是一整张大的图片，包含了整个操作界面的所有图片，xml就是用来切割分块这张大的图片，并分别给它们重新命名的，新的命名就会被前面的imagename 使用。

	inst.entity:SetPristine()

	return inst
end

STRINGS.NAMES.ROCK_SHOVEL = "多功能石铲"
STRINGS.RECIPE_DESC.ROCK_SHOVEL = "一铲在手天下我有" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROCK_SHOVEL = "也许我能客串一下某个骑士？"
return Prefab("common/inventory/nuclear_bomb", fn, assets,prefabs)