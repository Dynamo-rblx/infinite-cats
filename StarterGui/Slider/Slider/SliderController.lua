-- @ScriptType: LocalScript
-- Setting up unchanging variables
local bar = script.Parent.Bar;
local knob = bar.Knob;
local valueChangedEvent = script.Parent.ValueChanged;
local startXScale = -.05;
local endXScale = .95;
local mouse = game:GetService("Players").LocalPlayer:GetMouse()

-- Updates the position of the knob as well as the value
local prevValue = nil;
local function Update()
	local absPosition = script.Parent.Bar.AbsolutePosition.X;
	local absSize = script.Parent.Bar.AbsoluteSize.X;
	local mouseDelta = math.min(math.max(0, mouse.X - absPosition), absSize);
	local value = script.Parent.MinValue.Value + ((mouseDelta / absSize) * (script.Parent.MaxValue.Value - script.Parent.MinValue.Value));
	workspace:WaitForChild("Theme").Volume = value
	knob.Position = UDim2.new((mouseDelta / absSize) - .05, knob.Position.X.Offset, knob.Position.Y.Scale, knob.Position.Y.Offset);
	if (prevValue ~= nil and math.floor(prevValue) ~= math.floor(value)) then
		valueChangedEvent:Fire(prevValue, math.floor(value));
		prevValue = math.floor(value);
	else
		prevValue = math.floor(value);
	end
end

-- Coroutine to keep updating
local keepUpdating = false;
local function Updater()
	while (true) do
		if (keepUpdating) then
			Update()
		end
		wait(.05)
	end
end
local taskCoro = coroutine.create(Updater)
coroutine.resume(taskCoro);

-- Event Connecting
knob.MouseButton1Down:Connect(function()
	keepUpdating = true;
end)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.Touch then
		keepUpdating = true;
	end
end)
UserInputService.InputEnded:Connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
		keepUpdating = false;
	end
end)