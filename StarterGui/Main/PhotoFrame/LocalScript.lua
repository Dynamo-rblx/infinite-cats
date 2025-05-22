-- @ScriptType: LocalScript
script.Parent.MouseEnter:Connect(function()
	script.Parent:TweenSize(UDim2.new(.5,0,.9,0), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, .1, true)
end)

script.Parent.MouseLeave:Connect(function()
	script.Parent:TweenSize(UDim2.new(.45,0,.85,0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, .1, true)
end)