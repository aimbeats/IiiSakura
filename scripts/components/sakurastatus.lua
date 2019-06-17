local sakurastatus = Class(function(self, inst)
    self.inst = inst
end,
nil,
{
})

function sakurastatus:windPressure()
	self.inst:PushEvent("windPressure")
end
function sakurastatus:dodge()
	self.inst:PushEvent("dodge")
end
function sakurastatus:topspeed()
	self.inst:PushEvent("topspeed")
end
function sakurastatus:skill()
	self.inst:PushEvent("skill")
end

return sakurastatus