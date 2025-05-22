-- @ScriptType: Script
-- Define the AssetService variable
local AssetService = game:GetService("AssetService")

-- Set up PromptCreateAssetAsync() for prompting the submission dialog
local function CreateAsset(player, instance)
	local complete, result, assetId = pcall(function()
		return AssetService:PromptCreateAssetAsync(player, instance, Enum.AssetType.Model)
	end)

	if complete then
		if result == Enum.PromptCreateAssetResult.Success then
			print("successfully uploaded, AssetId:", assetId)
		else
			print("Received result", result)
		end
	else
		print("error")
		print(result)
	end
end

game:GetService("ReplicatedStorage"):WaitForChild("PublishNewAsset").OnServerEvent:Connect(function(plr, imageID, caption)
	local template = workspace:WaitForChild("FrameTemplate"):Clone()
	template:WaitForChild("Glass"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel").Text = caption
	template:WaitForChild("Picture"):WaitForChild("Decal").Texture = imageID
	
	CreateAsset(plr, template)
end)