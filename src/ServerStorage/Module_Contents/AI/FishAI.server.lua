 local pfService = game:GetService("PathfindingService")
local waterBlocks = game:GetService("ServerStorage").Voxels.Water
local swimBoundaries
local waterPrepared = game:GetService("ReplicatedStorage").SharedDatabase.VerifySetup:WaitForChild("1.WaterVoxel")

function start()
	repeat wait()
		swimBoundaries = waterBlocks:GetDescendants()[math.random(#waterBlocks:GetDescendants())]
	until swimBoundaries:isA("BasePart")
	 
	local self = script:FindFirstAncestorOfClass("Model")
	
	local elevationSplit = 4
	local bodyPosition = script:FindFirstChildOfClass("BodyPosition")
	local tweenService = game:GetService("TweenService")
	
	local function prepareFish()
		if not self.PrimaryPart then
			self.PrimaryPart = self.HumanoidRootPart
		end
		
		self:SetPrimaryPartCFrame(swimBoundaries.CFrame)
		
		if self.PrimaryPart:FindFirstChildOfClass("BodyPosition") then
			self.PrimaryPart:FindFirstChildOfClass("BodyPosition"):Destroy()
		end
		
		wait()
		bodyPosition.Parent = self.PrimaryPart
	end
	
	wait(1)
	
	local function makePath()
		if not self.PrimaryPart then warn("Missing Primary Part") return end
		return pfService:FindPathAsync(
			self:GetPrimaryPartCFrame().p,
				swimBoundaries.CFrame.p + Vector3.new(
				math.random(-(swimBoundaries.Size.X / 2), (swimBoundaries.Size.X / 2)),
				self:GetPrimaryPartCFrame().p.Y,
				math.random(-(swimBoundaries.Size.Z / 2), (swimBoundaries.Size.Z / 2))
			), math.huge):GetWaypoints()
	end
	
	local function elevation()
		local decide = math.random(1,2)
		if decide == 1 then 
			return math.random(0, swimBoundaries.Size.Y / math.random(1,elevationSplit))
		else
			return 0
		end
	end
	
	local function idleMove()
		local _wp = makePath()
		local pathSkip = math.random(1,3)
		if _wp == nil then warn("Waypoints are nil") return true end
		if #_wp <= pathSkip or #_wp == 0 then return true end
		for i = 2,#_wp, pathSkip do
			local yLift = elevation()
			local wp = _wp[i].Position + Vector3.new(0,yLift,0)
			bodyPosition.Position = wp
			bodyPosition.P = 10000
			if self:FindFirstChildOfClass("Humanoid"):GetState() ~= Enum.HumanoidStateType.Swimming then
				self:SetPrimaryPartCFrame(swimBoundaries.CFrame)
				bodyPosition.Position = self:GetPrimaryPartCFrame().p
				return true
			end
			
			local currCFrame = self.PrimaryPart.CFrame.p
			-- Tween fish to look at direction its heading
			spawn(function()
				tweenService:Create(self.PrimaryPart, TweenInfo.new(0.1), {CFrame = CFrame.new(currCFrame, wp)}):Play()
			end)
			
			local endWait = false
			
			spawn(function()
				wait(2)
				endWait = true
			end)
			
			repeat wait(0.05)
				currCFrame = self.PrimaryPart.CFrame.p
				-- Make fish look at area its heading too
			until (self:GetPrimaryPartCFrame().p - wp).magnitude < 5 or endWait
			if math.random(1,10) == 3 then
				return true
			end
		end
		return true
	end
	
	local success = pcall(prepareFish)
	
	if not success then
		error("Fish AI > Error preparing fish")
	end
	
	while wait() do
		idleMove()
	end
	
	error("Error occured, loop ended")
end

waterPrepared:GetPropertyChangedSignal("Value"):Connect(function()
	start()
end)