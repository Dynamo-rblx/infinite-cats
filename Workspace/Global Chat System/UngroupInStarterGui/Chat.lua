-- @ScriptType: LocalScript
game.ReplicatedStorage.Chat.OnClientEvent:Connect(function(msg)
	
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		
		Text = msg;
		Font = Enum.Font.SourceSansBold;
		Color = Color3.new(255,255,255);
		FontSize = Enum.FontSize.Size14;
		
	})
	
end)