warn("Client-Sided Feedback System")

script.Parent.FeedbackButton.Position = UDim2.new(0.5, -100,-0.5, 10)
script.Parent.FeedbackBox.Position = UDim2.new(0.5, 0, 1.5, 0)

local feedbackPause = 0

local function readInput(input)
	if #input.Text < 5 then input.Text = "Not enough characters to send post" return false end;
	if #input.Text > 500 then input.Text = "Too many characters. (Must be less than 500)" return false end
	if input.Text:gsub(" ", "") == "" then return false  end
	if input.Text == "Write feedback here..." then input.Text = "There is no feedback" return false  end
	if input.Text == "There is no feedback" then return false end
	print("Successful")
	return true
end

local function startPause()
	for i = 60, 0, -1 do
		feedbackPause = i
		script.Parent.FeedbackButton.Text = "Please wait... (".. i .. ")"
		wait(1)
	end
	script.Parent.FeedbackButton.Text = "Send Feedback"
	feedbackPause = 0
end

local function sendInput(feedbackType)
	if feedbackPause ~= 0 then print("Feedback System - Request Delay is still active") return end

	if readInput(script.Parent.FeedbackBox.Input) == false then return end
	local feedback  = script.Parent.FeedbackBox.Input.Text
	script.Parent.FeedbackBox.Input.Text = "Sending Feedback..."
	if game.ReplicatedStorage.SharedDatabase.Remotes.FromClient:WaitForChild("SendFeedback"):InvokeServer(feedbackType .. " - " .. feedback) then
		script.Parent.FeedbackBox.Input.Text = "Thank you very much! ~ RaulByte"
	else
		script.Parent.FeedbackBox.Input.Text = "An error occured, please try again later"
	end
	startPause()
	script.Parent.FeedbackBox:TweenPosition(UDim2.new(0.5, 0, 1.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 2)
end
script.Parent.FeedbackBox.Suggestion.MouseButton1Click:Connect(function()
	sendInput("suggestion")
end)

script.Parent.FeedbackBox.Bug_Report.MouseButton1Click:Connect(function()
	sendInput("bug")
end)	
	
local function start()
	script.Parent.FeedbackButton:TweenPosition(UDim2.new(0.5, -100, 0, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 2)
	
	local feedBoxOpen = false
	script.Parent.FeedbackButton.MouseButton1Click:Connect(function()
		if feedBoxOpen then return end
		feedBoxOpen = true
		
		if script.Parent.FeedbackBox.Position.Y.Scale == 0.5 then
			script.Parent.FeedbackBox:TweenPosition(UDim2.new(0.5,0,1.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1)
		else
			script.Parent.FeedbackBox:TweenPosition(UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1)
		end
		
		wait(1)
		feedBoxOpen = false
	end)
end

script.parent.Notice.Position = UDim2.new(0.5,0,1.5,0)
script.Parent.Notice:TweenPosition(UDim2.new(0.5,0,0.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1)

script.Parent.Notice.TextButton.MouseButton1Click:Connect(function()
	script.Parent.Notice:TweenPosition(UDim2.new(0.5,0,1.5,0), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 1)
	wait(1)
	start()
end)
