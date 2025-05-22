-- @ScriptType: LocalScript
local OnlineCount = script.Parent:WaitForChild("Main"):WaitForChild("UserCountOnline")
local OfflineCount = script.Parent:WaitForChild("Main"):WaitForChild("UserCountOffline")
local TotalCount = script.Parent:WaitForChild("Main"):WaitForChild("UserCountTotal")
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)

local function sortText(num)
	local values = {{1000, "K"}, {1000000, "M"}, {1000000000, "B"}}
	local str = ""
	if type(num) ~= "number" then num = tonumber(num) end
	for i = 1, #values do
		if num >= values[i][1] then
			str = (math.floor(num / values[i][1]))..values[i][2]
		end
	end
	return (num < 1000 and num or str)
end

while task.wait() do
	if script.Parent:FindFirstChild("TouchGui") then
		if script.Parent:FindFirstChild("TouchGui").Enabled then
			game.GuiService.TouchControlsEnabled = false
			game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
			
		end
	end

	OnlineCount.Text = sortText(workspace:WaitForChild("Users Online").Value).." Online"
	OfflineCount.Text = sortText(workspace:WaitForChild("Users Offline").Value).." Offline"
	TotalCount.Text = "Users: "..sortText(workspace:WaitForChild("TotalUsers").Value)
end