-- @ScriptType: Script
local MessagingService = game:GetService("MessagingService")

MessagingService:SubscribeAsync("GlobalChat", function(msg)
	
	local splitMessageForPlayer = string.split(msg.Data, "sTrInGsEpErAtOr")
	
	if not game.Players:FindFirstChild(splitMessageForPlayer[1]) then
		
		game.ReplicatedStorage.Chat:FireAllClients(splitMessageForPlayer[2])
		
	end
	
end)

game.Players.PlayerAdded:Connect(function(plr)
	
	plr.Chatted:Connect(function(msg)
		
		local filteredChatMessage = game:GetService("Chat"):FilterStringForBroadcast(msg, plr)
		
		local finalMessage = "["..plr.Name.."]: "..filteredChatMessage
		
		MessagingService:PublishAsync("GlobalChat", plr.Name.."sTrInGsEpErAtOr"..finalMessage)
		
	end)
	
end)