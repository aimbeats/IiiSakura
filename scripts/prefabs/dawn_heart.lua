--***************************************************************
--破晓之心
--***********************************************************************
local assets=
{ 
    Asset("ANIM", "anim/dawn_heart.zip"),--这个是放在地上的动画文件
    Asset("ATLAS", "images/inventoryimages/dawn_heart.xml"),--物品栏图标的xml
}
--有关的预制物，但是还没用到过
local prefabs = {}

local function fn()--这个函数就是实际创建物体的函数，上面所有定义到的函数，变量，都需要直接或者间接地在这个函数中使用，才能起作用
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork() --让所有人都能看到这个东西
     
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("dawn_heart")
    inst.AnimState:SetBuild("dawn_heart")
    inst.AnimState:PlayAnimation("idle")

	if not TheWorld.ismastersim then
        return inst
    end
 
    inst.entity:SetPristine()

    inst:AddComponent("inventoryitem")--添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
    inst.components.inventoryitem.imagename = "dawn_heart" --物品栏图片的名字
    inst.components.inventoryitem.atlasname = "images/inventoryimages/dawn_heart.xml"--物品栏图片的xml文件。为什么会有这么两句呢？在单个文件下也许会迷惑，但如果换成一个张大图就容易理解了。举个例子，游戏的操作界面,HUD，你可以在data\images下找到HUD.tex，用textool打开就会看到是一整张大的图片，包含了整个操作界面的所有图片，xml就是用来切割分块这张大的图片，并分别给它们重新命名的，新的命名就会被前面的imagename 使用。
    
    inst:AddComponent("stackable")--添加叠加功能
    inst.components.stackable.maxsize = 40

    inst:AddComponent("edible")--可食用
    inst.components.edible.foodtype = "GENERIC" --设定食物的荤素,通用属性是啥？
    inst.components.edible.healthvalue = 100
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 100
    return inst
end
STRINGS.NAMES.DAWN_HEART = "救赎之心"
STRINGS.RECIPE_DESC.DAWN_HEART = "良善者的座右铭" 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DAWN_HEART = "如果可以，我不想有得到它的机会"
return Prefab("common/inventory/dawn_heart", fn, assets, prefabs)--最后，返回这个实体到modmain里注册。Prefab这个函数，第一个参数只需要看最后一个/后面的部分，视为这个prefab的ID，fn则是上面定义的fn，是这个物品的创建函数，assets，对应上面的assets，主要是用于注册美术资源，如果你在这里注册了相应的美术资源，就不需要在modmain里再注册一次。prefabs，目前还未明确具体的作用。