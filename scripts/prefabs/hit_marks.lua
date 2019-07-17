--***************************************************************
--锁定打击目标的预设物
--***********************************************************************
local assets =
{
    Asset("ANIM", "anim/fox_mask.zip")
}
local function spark(inst)
	local damage = 5000
	local x, y, z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 40)
	for k,v in pairs(ents) do
		if v.components.health then
			if v:HasTag("player") then
				v:ShakeCamera(CAMERASHAKE.FULL, .7, .05, 1)
			end
			if v.components.combat and not v:HasTag("player") and not v:HasTag("sparked") then
				v.components.combat:GetAttacked(inst, damage)
			elseif v:HasTag("player") and TheNet:GetPVPEnabled() and not v:HasTag("sparked") and not v.prefab == "iiisakura" then
				v.components.combat:GetAttacked(inst, damage)
			--点燃摧毁一切可燃烧物品
			elseif v and v:IsValid() and v.components.burnable then
				v.components.burnable:OnRemoveFromEntity()
			end
			end
	end
end

-- local function dull(inst)
-- 	inst.light = inst.light - 0.03
-- 	inst.AnimState:SetMultColour(inst.light,inst.light,inst.light,inst.light)
-- end


local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.AnimState:SetBank("hit_marks")
    inst.AnimState:SetBuild("hit_marks")
    inst.AnimState:PlayAnimation("idle",true)
    inst.AnimState:SetLightOverride(1)
	-- inst.AnimState:SetMultColour(0.3,0.3,0.3,0.3)
	inst.light = 0.3

    inst.entity:AddTransform()
    inst.entity:AddNetwork() --让所有人都能看到这个东西

    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(3.5, 3.5, 3.5)

	inst.entity:SetPristine()
	
	inst:AddComponent("explosive") --添加爆炸组件
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = TUNING.GUNPOWDER_DAMAGE

    if not TheWorld.ismastersim then
        return inst
    end
	inst:DoTaskInTime(15, spark) --15秒后对目标区域进行核弹打击
    inst:DoTaskInTime(15.55, inst.Remove) --移除预设物

    return inst
end

return Prefab("hit_marks", fn, assets, prefabs)