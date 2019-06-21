local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
	Asset( "ANIM", "anim/iiisakura.zip" ),
	Asset( "ANIM", "anim/ghost_iiisakura_build.zip" ),
}

local prefabs = {}

--人物出生自带的物品
local start_inv = {
	"thorne_dachi",
	"rock_shovel",
	"stealth_dachi",
	"cutgrass",
	"laser_pointer",
	"fox_mask"
}
--这将为服务器和客户机初始化。标签可以在这里添加。
local common_postinit = function(inst)
	-- 小地图图标
	inst.MiniMapEntity:SetIcon( "iiisakura.tex" )
	inst:AddTag("iiisakura")
	--未知
	inst:AddTag("iiisakura_builder")
end
--定义八重樱能力倍率变量
local ratedata =
{
	normal = {
		multiplier_normal = 1,
			},
	rage = {
		multiplier_normal = 1.5,
			},
	half_disintegration = {
		multiplier_normal = 2,
			},
	disintegration = {
		multiplier_normal = 3,
			},
}
local statedata = 'disintegration'
--根据理智状态修改对应的能力
local function onCapacity(inst,state)
	inst.state = state
	--攻击频率
	-- inst.components.combat.min_attack_period = (4 * rate[state].multiplier_normal)
	--走路移动速度
	inst.components.locomotor.walkspeed = (4 + ratedata[statedata].multiplier_normal)
	--跑路移动速度
	inst.components.locomotor.runspeed = (6 + ratedata[statedata].multiplier_normal)
	--饥饿速度
	inst.components.hunger.hungerrate = (0.15 * ratedata[statedata].multiplier_normal)
	--增加所受伤害
	inst.components.health:SetAbsorptionAmount(0.5 + ratedata[statedata].multiplier_normal * -1 / 2)
	--范围攻击
	-- inst.components.combat.SetAreaDamage(0.5 + rate[state].multiplier_normal * -1 / 2)
end
--根据理智状态切换人物形态动画
local function onForm(inst,state)
	inst.state = state
	if state == "disintegration" then
		inst.components.talker:Say("进入崩坏状态")
		-- inst.AnimState:SetBuild("iiisakura_rage")
	elseif state == "half_disintegration" then
		inst.components.talker:Say("进入半崩坏状态")
		-- inst.AnimState:SetBuild("iiisakura_half_disintegration")
	elseif state == "rage" then
		inst.components.talker:Say("进入狂暴状态")
		-- inst.AnimState:SetBuild("iiisakura_disintegration")
	else
		inst.components.talker:Say("进入正常状态")
		-- inst.AnimState:SetBuild("iiisakura")
	end
end
--判断理智范围触发能力修改的函数和标签
local function onsanitychange(inst)
	local percent = inst.components.sanity:GetPercent()
	if percent < 0.1 and not inst:HasTag("disintegration") then
		inst:AddTag("disintegration")
		inst:RemoveTag("half_disintegration")
		inst:RemoveTag("normal")
		inst:RemoveTag("rage")
		statedata = "disintegration"
		onCapacity(inst,"disintegration")
		onForm(inst,"disintegration")
	elseif percent < 0.5 and percent > 0.25 and not inst:HasTag("half_disintegration") then
		inst:AddTag("half_disintegration")
		inst:RemoveTag("normal")
		inst:RemoveTag("rage")
		inst:RemoveTag("disintegration")
		statedata = "half_disintegration"
		onCapacity(inst,"half_disintegration")
		onForm(inst,"half_disintegration")
	elseif percent < 0.75 and percent > 0.5 and not inst:HasTag("rage") then
		inst:AddTag("rage")
		inst:RemoveTag("half_disintegration")
		inst:RemoveTag("normal")
		inst:RemoveTag("disintegration")
		statedata = "rage"
		onCapacity(inst,"rage")
		onForm(inst,"rage")
	elseif percent < 1 and percent > 0.75 and not inst:HasTag("normal") then
		inst:AddTag("normal")
		inst:RemoveTag("half_disintegration")
		inst:RemoveTag("rage")
		inst:RemoveTag("disintegration")
		statedata = "normal"
		onCapacity(inst,"normal")
		onForm(inst,"normal")
	else
		return
  end
end
--***************************************************************
--主动技能及相关函数
--***********************************************************************
--雾鸦·雷鸣技能函数
local function getAttack(inst,data)
	--覆盖GetAttacked函数
	inst.components.combat.oldAttacked = inst.components.combat.GetAttacked
	--监听是否是被攻击
	function inst.components.combat:GetAttacked(attacker, damage, weapon)
		--如果拥有dodge闪避标签则执行闪避操作
		if inst:HasTag("dodge") then
			inst.components.talker:Say("雷鸣!")
			local x, y, z = inst.Transform:GetWorldPosition()--获取主角的位置
			inst.Transform:SetPosition(x+math.random(-10, 10),y+math.random(-10, 10),z+math.random(-10, 10)) --随机转移
			local pos = attacker:GetPosition()
    		SpawnPrefab("lightning_rod_fx").Transform:SetPosition(attacker.Transform:GetWorldPosition())--加载闪电动画
			attacker.components.combat:GetAttacked(inst,50,nil) --对攻击者反伤50
			inst:RemoveTag("dodge") --移除闪避状态标签
			inst:DoTaskInTime( 5, function() inst:RemoveTag("cd_dodge") end)--5秒后移除技能冷却标签。
			inst:RemoveEventCallback("attacked",getAttack)--执行过一次之后，就移除监听器。
			return inst.components.combat:oldAttacked(attacker, damage, weapon)
		end
	end
end
--主动技能Z：风压
local function windPressure(inst)
	if not inst:HasTag("cd_windPressure") then
		inst.components.talker:Say("风压")
		inst.components.hunger:DoDelta(-10)
		local pos = Vector3(inst.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 8)
		--检测人物范围内所有物体
		for k,v in pairs(ents) do
				--破坏树木建筑
				if v:HasTag("tree") and v.components.workable and v.components.workable.workleft > 0 then
					v.components.workable:Destroy(inst)
				end
				--对敌人造成10伤害并击退
				if v and v:IsValid() and v ~= inst and v.components.health and not v.components.health:IsDead() then
					local pt01 = inst:GetPosition()
					local pt02 = v:GetPosition()
					v.Transform:SetPosition((pt02.x-pt01.x)*1.5+pt02.x, 0, (pt02.z-pt01.z)*1.5+pt02.z)
				  	v.components.combat:GetAttacked(inst, 10)
					inst.components.sanity:DoDelta(1) --用于抵消人物攻击时损失的精神值
				end
		end
		--产生画面震动效果
		inst:ShakeCamera(CAMERASHAKE.FULL, .7, .02, .3, inst, 40)
		inst:AddTag("cd_windPressure")--赋上冷却状态标签
		inst:DoTaskInTime( 10, function() inst:RemoveTag("cd_windPressure") end)--10秒后移除技能冷却标签。
	else
		inst.components.talker:Say("风压技能冷却中")
	end
end
--主动技能X：雾鸦·雷鸣
local function dodge(inst)
	--inst.AnimState:PlayAnimation("crash")--加载雾鸦动画
	if not inst:HasTag("cd_dodge") then
		inst:AddTag("dodge")--赋上闪避状态标签
		inst:AddTag("cd_dodge")--赋上冷却状态标签
		inst.components.talker:Say("雾鸦")
		inst:ListenForEvent("attacked",getAttack)--设置一个监听器。
		--3秒后如果未受到攻击执行事件：移除闪避标签和监听器
		inst:DoTaskInTime(3,function()
			if inst:HasTag("dodge") then
				inst.components.talker:Say("未受到攻击")
				inst:RemoveTag("dodge")--移除闪避状态标签
				inst:RemoveTag("cd_dodge")--移除冷却状态标签
				inst:RemoveEventCallback("attacked",getAttack)--移除监听器。
			end
		end)
	else
		inst.components.talker:Say("雾鸦技能冷却中")
	end
end
--主动技能C：雷动
local function topspeed(inst)
	-- inst.components.sanity:DoDelta(-10)
	--inst.AnimState:PlayAnimation("crash")--加载雷动动画
	if not inst:HasTag("topspeed") then
		inst.components.talker:Say("雷动已开启")
		inst:AddTag("topspeed")--赋上雷动状态标签
		--移动速度加快
		inst.components.locomotor.walkspeed = 10
		inst.components.locomotor.runspeed = 12
		inst.topspeed_delayed = inst:DoPeriodicTask(1, function(inst)
			inst.components.hunger:DoDelta(-2)
		end)
	else
		inst.components.talker:Say("雷动状态已解除")
		inst:RemoveTag("topspeed")--移除雷动状态标签
		--走路移动速度
		inst.components.locomotor.walkspeed = (4 + ratedata[statedata].multiplier_normal)
		--跑路移动速度
		inst.components.locomotor.runspeed = (6 + ratedata[statedata].multiplier_normal)
		--走路移动速度
		inst.topspeed_delayed:Cancel()
		inst.topspeed_delayed = nil
	end
end
--瞬剑·繁华落尽监听是否移动
local function iswalk(inst)
	if inst.components.locomotor.wantstomoveforward then
		inst:AddTag("cancel_skill")
		inst:RemoveEventCallback("locomote",iswalk)--执行过一次之后，就移除监听器。
		inst.components.talker:Say("移动打断大招")
	end
end
--主动技能V：瞬剑·繁华落尽
local function skill(inst)
	if not inst:HasTag("cd_heat") then
		inst:AddTag("cd_heat")--赋上大招状态标签
		
		inst.components.talker:Say("瞬剑")
		inst.components.locomotor:Stop()
		--inst.AnimState:PlayAnimation("crash")--加载起手动画
		inst:ListenForEvent("locomote",iswalk)--设置一个监听器监听是否在移动。
		--1秒后开始攻击
		inst:DoTaskInTime(1,function(inst)
			inst.components.talker:Say("繁华落尽")
			inst:AddTag("cd_skill")
			--inst.AnimState:PlayAnimation("crash")--加载爆发时的动画
			inst.skill_delayed = inst:DoPeriodicTask(2, function(inst)--每2秒对敌人造成50伤害
				if not inst:HasTag("cancel_skill") then
					inst.components.hunger:DoDelta(-20)
					inst.components.health:DoDelta(-20)
					inst.components.sanity:DoDelta(-20)
					local pos = Vector3(inst.Transform:GetWorldPosition())
					local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 10)
					--检测人物范围内所有物体
					for k,v in pairs(ents) do
						if v and v:IsValid() and v ~= inst and v.components.health and not v.components.health:IsDead() then
							v.components.combat:GetAttacked(inst, 90)
							inst.components.sanity:DoDelta(1) --用于抵消攻击时损失的精神值
						end
					end
				else 
					if inst:HasTag("cd_skill") then
						inst.skill_delayed:Cancel()
						inst.skill_delayed = nil
						inst:RemoveTag("cd_skill")
					end
					inst:RemoveTag("cancel_skill")
					inst.components.talker:Say("结束")
					inst:RemoveTag("cd_heat")
				end
			end)
		end)
	else
		if inst:HasTag("cd_skill") then
			inst.skill_delayed:Cancel()
			inst.skill_delayed = nil
			inst:RemoveTag("cd_skill")
		end
		if inst:HasTag("cancel_skill") then
			inst:RemoveTag("cancel_skill")
		end
		inst.components.talker:Say("结束")
		inst:RemoveTag("cd_heat")
	end
end
--***************************************************************
--下面是人物的属性值
--***********************************************************************
local master_postinit = function(inst)

	--语音和地图图标
	inst.soundsname = "wilson"

  	inst.components.health:SetMaxHealth(225)
	inst.components.hunger:SetMax(300)
	inst.components.sanity:SetMax(200)
	--伤害系数
	inst.components.combat.damagemultiplier = 1.2
	--走路移动速度
	inst.components.locomotor.walkspeed = 5
	--跑路移动速度
	inst.components.locomotor.runspeed = 7
	--饥饿速度
	inst.components.hunger.hungerrate = 0.15
	--设置免伤百分比
	inst.components.health:SetAbsorptionAmount(0)
	--自动回血
	inst.components.health:StartRegen(1, 10)
	--攻击损失精神
	inst:ListenForEvent("onhitother",function(inst,data)
		inst.components.sanity:DoDelta(-1)
	end)
	--理智监听
	inst:ListenForEvent("sanitydelta", onsanitychange)
	--注册按钮监听组件
	-- inst:AddComponent("iiisakura_keyhandler")
	inst:AddComponent("sakurastatus")
	--按钮监听事件
	inst:ListenForEvent("windPressure", windPressure)
	inst:ListenForEvent("dodge", dodge)
	inst:ListenForEvent("topspeed", topspeed)
	inst:ListenForEvent("skill", skill)
	-- 理智光环
	inst:DoPeriodicTask(20,function() 
		local pos = Vector3(inst.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 8)
		for k,v in pairs(ents) do
			if  v.components.sanity then              
				v.components.sanity:DoDelta(1) 
			end
		end
	end)
	-- 	--科技水平
	inst.components.builder.science_bonus = 1
    -- end)

end

STRINGS.CHARACTER_TITLES.iiisakura = "八重樱"
STRINGS.CHARACTER_NAMES.iiisakura = "八重樱"
STRINGS.CHARACTER_DESCRIPTIONS.iiisakura = "守护一世的巫女，却失去最应守护的珍爱"
STRINGS.CHARACTER_QUOTES.iiisakura = "我想守护的人都已不在"
STRINGS.CHARACTERS.IIISAKURA = require "speech_iiisakura"

return MakePlayerCharacter("iiisakura", prefabs, assets,common_postinit,master_postinit,start_inv)
