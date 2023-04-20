local links = {
	{script.Parent.Head.NeckRigAttachment; script.Parent.UpperTorso.NeckRigAttachment;};
	{script.Parent.UpperTorso.WaistRigAttachment; script.Parent.LowerTorso.WaistRigAttachment};
	
	{script.Parent.LowerTorso.LeftHipRigAttachment; script.Parent.LeftUpperLeg.LeftHipRigAttachment};
	{script.Parent.LowerTorso.RightHipRigAttachment; script.Parent.RightUpperLeg.RightHipRigAttachment};
	
	{script.Parent.LeftUpperLeg.LeftKneeRigAttachment; script.Parent.LeftLowerLeg.LeftKneeRigAttachment};
	{script.Parent.RightUpperLeg.RightKneeRigAttachment; script.Parent.RightLowerLeg.RightKneeRigAttachment};
	
	{script.Parent.RightLowerLeg.RightAnkleRigAttachment; script.Parent.LeftFoot.LeftAnkleRigAttachment};
	{script.Parent.LeftLowerLeg.LeftAnkleRigAttachment; script.Parent.RightFoot.RightAnkleRigAttachment};
	
	{script.Parent.UpperTorso.LeftShoulderRigAttachment; script.Parent.LeftUpperArm.LeftShoulderAttachment};
	{script.Parent.UpperTorso.RightShoulderRigAttachment; script.Parent.RightUpperArm.RightShoulderRigAttachment};
	
	{script.Parent.LeftUpperArm.LeftElbowRigAttachment; script.Parent.LeftLowerArm.LeftElbowRigAttachment};
	{script.Parent.RightUpperArm.RightElbowRigAttachment; script.Parent.RightLowerArm.RightElbowRigAttachment};
	
	{script.Parent.LeftLowerArm.LeftWristRigAttachment; script.Parent.LeftHand.LeftWristRigAttachment};
	{script.Parent.RightLowerArm.RightWristRigAttachment; script.Parent.RightHand.RightWristRigAttachment};
}

local function addJoints()
	local props = {LimitsEnabled = true; TwistLimitsEnabled = true; UpperAngle = 20}
	for _,v in pairs(links) do
		local ballJoint = Instance.new("BallSocketConstraint")
		ballJoint.Attachment0 = v[1]
		ballJoint.Attachment1 = v[2]
		ballJoint.Parent = v[1]
		
		for i,v in pairs(props) do
			ballJoint[i] = v
		end
	end
end

script.Parent.Humanoid.Died:Connect(function()
	--script.DropSpinner:Clone().Parent = script.Parent.UpperTorso
	addJoints()
end)
