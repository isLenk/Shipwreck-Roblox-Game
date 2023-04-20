-- This tree runs away when attacked
local health = script.Parent.Health
local lastHP = health.Value

function run()
	script.Parent.Foliage.Anchored = false
	script.Parent.Trunk.Anchored = false
	script.Parent.Monster:MoveTo(Vector3.new(math.random(1,10), Vector3.new(math.random(1,10), Vector3.new(math.random(1,10)))))
end

health:GetPropertyChangedSignal("Value"):Connect(function()
	if health.Value < lastHP then
		run()
	end
end)