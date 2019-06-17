--***************************************************************
--这里的代码用于客机向主机发送技能参数的，还有技能获取
--***********************************************************************

local ThePlayer = GLOBAL.ThePlayer
local TheInput = GLOBAL.TheInput
local TheNet = GLOBAL.TheNet
local SpawnPrefab = GLOBAL.SpawnPrefab

--这个是用于查看个人信息的，暂时不需要
AddModRPCHandler(modname, "check", function(player)
	player.components.talker:Say('跟我一起喊：浩儿子永远抽不到能天使！')
end)

AddModRPCHandler(modname, "windPressure", function(player)
	player.components.sakurastatus:windPressure()
end)
AddModRPCHandler(modname, "dodge", function(player)
	player.components.sakurastatus:dodge()
end)
AddModRPCHandler(modname, "topspeed", function(player)
	player.components.sakurastatus:topspeed()
end)
AddModRPCHandler(modname, "skill", function(player)
	player.components.sakurastatus:skill()
end)
local sakura_handlers = {}
AddPlayerPostInit(function(inst)
	inst:DoTaskInTime(0, function()
		if inst == GLOBAL.ThePlayer then
			if inst.prefab == "iiisakura" then
				sakura_handlers[0] = TheInput:AddKeyDownHandler(TUNING.checkKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["check"])
            		end
				end)
				sakura_handlers[1] = TheInput:AddKeyDownHandler(TUNING.windPressureKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["windPressure"])
					end
				end)
				sakura_handlers[2] = TheInput:AddKeyDownHandler(TUNING.dodgeKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["dodge"])
					end
				end)
				sakura_handlers[3] = TheInput:AddKeyDownHandler(TUNING.topspeedKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["topspeed"])
					end
				end)
				sakura_handlers[4] = TheInput:AddKeyDownHandler(TUNING.skillKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["skill"])
					end
				end)
			else
				sakura_handlers[0] = nil
				sakura_handlers[1] = nil
				sakura_handlers[2] = nil
				sakura_handlers[3] = nil
				sakura_handlers[4] = nil
			end
		end
	end)
end)