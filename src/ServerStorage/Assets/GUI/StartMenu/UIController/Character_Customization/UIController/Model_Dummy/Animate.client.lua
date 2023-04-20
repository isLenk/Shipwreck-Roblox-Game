function playRandAnim()
	script.Parent.Humanoid:LoadAnimation(script:WaitForChild("idle"):GetChildren()[math.random(#script.idle:GetChildren())]):Play()	
end

playRandAnim()
while wait(4) do
playRandAnim()
end