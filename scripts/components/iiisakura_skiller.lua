
-- local function onmax(self,max)
-- 	self.inst.maxmana:set(max)
-- end
-- local function oncurrent(self,current)
-- 	self.inst.currentmana:set(current)
-- end
-- local function onlotus_charge(self,charge)
-- 	self.inst.lotus_charge:set(charge)
-- 	if charge >= 100 and self.fadetime == 0 then
-- 		self.fadetime = 0.1
-- 		self.inst.components.bloomer:PushBloom("lotus_charged", "shaders/anim.ksh", 1)
-- 	end
-- end
-- local sa_skiller = Class(function(self, inst)
-- 	self.inst = inst
	
	
-- 	self.maxmana = 150
-- 	self.currentmana = self.maxmana

-- 	self.manacost = {}
-- 	self.onfn ={}
-- 	self.offfn = {}
-- 	self.testfn = {}
-- 	self.fading = false
-- 	self.fadetime = 0
-- 	self.lotus_charge = 0
-- 	local period = 1
-- 	inst:DoPeriodicTask(period,function(inst)
-- 		if TheWorld.state.isday then
-- 			local delta = inst:HasTag("zening") and period/2 or period/10
-- 			self.lotus_charge = self.lotus_charge + delta
-- 			self:ManaDoDelta(period/4)
-- 		end
-- 		if inst.sg:HasStateTag("sleeping") then
-- 			self:ManaDoDelta(period*2)
-- 		end		
-- 		if self:GetManaPercent() < 1 and inst:HasTag("zening")then
-- 			inst.components.sanity:DoDelta(-5)
-- 			self:ManaDoDelta(5)
-- 			print("打坐")
-- 		end
-- 		if self.fadetime > 0 then
-- 			self.fadetime = self.fadetime + period
-- 		end
-- 		if self.fadetime >= 960 then
-- 			self.fadetime = 0
-- 			self.lotus_charge = 0
-- 			inst.components.bloomer:PopBloom("lotus_charged")
-- 		end
		
-- 	end)
-- 	--击杀增加Mana上限
-- 	inst:ListenForEvent("killed",function(inst,data)
-- 		if data and data.victim and data.victim.components.health then
-- 			if data.victim:HasTag("epic") then
-- 				self:SetMaxMana(10,true)
-- 				return
-- 			end
-- 			local num =  math.floor(data.victim.components.health.maxhealth / 100)
-- 			if math.random() < num*0.05 then
-- 				self:SetMaxMana(5,true)
-- 			end
-- 		end
-- 	end)
-- end,
-- nil,
-- {
-- 	maxmana = onmax,
-- 	currentmana = oncurrent,
-- 	lotus_charge = onlotus_charge,
-- })



--流程：SkillTest --> ActivatedSkill -->onfn/offfn --> ManaDoDelta 
function sa_skiller:SkillTest(id)
	-- 这个不知道是校验什么的
	-- if self.onactivating and self.onactivating == id then
	-- 	return true
	-- end
	if self.manacost[id] and self.manacost[id] > self.currentmana then
		self.inst.components.talker:Say("能量不足")
		return false
	end
	if self.testfn[id] and not self.testfn[id](self.inst) then
		self.inst.components.talker:Say("无法满足技能使用条件")
		return false
	end
	return true
end

function sa_skiller:ActivatedSkill(id) 
	-- local closeskill = false
	-- if self.onactivating and self.onactivating == id then
	-- 	closeskill = true
	-- end
	-- if self:SkillTest(id) then
	-- 	if self.onactivating then
	-- 		self.offfn[self.onactivating](self.inst)
	-- 	end
	-- 	if self.onfn[id] and not closeskill then
	-- 		self.onfn[id](self.inst)
	-- 		self:ManaDoDelta(-self.manacost[id])--如果是执行函数，就给出Mana消耗。
	-- 	end
	-- end
end

function sa_skiller:addskill(id,manacost,onfn,offfn,testfn)
	self.manacost[id] = manacost
	if offfn then--持续性技能，启动相应函数时，要取消/记录当前持续中的技能
		self.offfn[id] = function(inst)
			self.onactivating = nil
			offfn(inst,self)
		end
		self.onfn[id] = function(inst)
			self.onactivating = id
			onfn(inst,self)
		end
	else--非持续性技能，直接执行
		self.onfn[id] = function(inst)
			onfn(inst,self)
		end
	end
	if testfn then
		self.testfn[id] = testfn
	end
	
-- end
-- function sa_skiller:ManaDoDelta(delta)
-- 	if delta < 0 then
-- 		delta = delta * (1- 0.75*math.min(self.lotus_charge,100)/100)
-- 	end
-- 	self.currentmana = math.min(self.currentmana + delta,self.maxmana)

-- end
-- function sa_skiller:SetMaxMana(maxmana,delta)
-- 	if delta then
-- 		self.maxmana = self.maxmana + maxmana
-- 	else
-- 		self.maxmana = maxmana
-- 	end
-- end
-- function sa_skiller:OnSave()
-- 	return {
-- 		currentmana = self.currentmana,
-- 		maxmana = self.maxmana,
-- 		lotus_charge = self.lotus_charge,
-- 		fadetime = self.fadetime,
-- 		}
-- end
-- function sa_skiller:OnLoad(data)
--     if data.currentmana ~= nil and self.currentmana ~= data.currentmana then
--         self.currentmana = data.currentmana
--     end
--     if data.maxmana ~= nil and self.maxmana ~= data.maxmana then
--         self.maxmana = data.maxmana
--     end	
-- 	if data.lotus_charge and self.lotus_charge ~= data.lotus_charge then
-- 		self.lotus_charge = data.lotus_charge
-- 	end
-- 	if data.fadetime and self.fadetime ~= data.fadetime then
-- 		self.fadetime = data.fadetime
-- 	end
-- end
-- function sa_skiller:AddLotusSkill(id)


-- end
-- function sa_skiller:ActivateLotusSkill(id)
-- 	if self.lotus_charge >= 100 then
-- 		self.lotus_charge = 0
-- 	end
-- end
-- function sa_skiller:GetManaPercent()

-- 	return self.currentmana/self.maxmana
-- end
return sa_skiller