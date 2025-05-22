-- @ScriptType: Script
local DSS = game:GetService("DataStoreService")
local DS = DSS:GetDataStore("Watcher Data")
local DS2 = DSS:GetDataStore("Player Data")
local DS3 = DSS:GetDataStore("Users_")

local RE_Update = game:GetService("ReplicatedStorage"):WaitForChild("UpdateDatastore")
local RE_GetData = game:GetService("ReplicatedStorage"):WaitForChild("GetData")
local RE_ReturnData = game:GetService("ReplicatedStorage"):WaitForChild("ReturnData")

game.Players.PlayerAdded:Connect(function(plr)
	local lb = Instance.new("Folder", plr)
	lb.Name = "Stats"

	local likedPhotos = Instance.new("Folder", lb)
	likedPhotos.Name = "Liked"

	local storedLiked = DS2:GetAsync(tostring(plr.UserId).." Liked")

	if not(storedLiked) then storedLiked = {} end

	for i, v in pairs(storedLiked) do
		local val = Instance.new("BoolValue", likedPhotos)
		val.Name = tostring(v)
		val.Value = true
	end
	
	if not(DS3:GetAsync("online")) then DS3:SetAsync("online", 0) end
	if not(DS3:GetAsync("total")) then DS3:SetAsync("total", 0) end
	if not(DS3:GetAsync("allUsers")) then DS3:SetAsync("allUsers", {}) end
	
	DS3:SetAsync("online", DS3:GetAsync("online")+1)
	
	
	if not(table.find(DS3:GetAsync("allUsers"), plr.Name)) then
		local allUsers = DS3:GetAsync("allUsers")
		table.insert(allUsers, plr.Name)
		DS3:SetAsync("allUsers", allUsers)
		DS3:SetAsync("total", #allUsers)
	end
	
	workspace:WaitForChild("Users Online").Value = DS3:GetAsync("online")
	workspace:WaitForChild("TotalUsers").Value = DS3:GetAsync("total")
	workspace:WaitForChild("Users Offline").Value = DS3:GetAsync("total") - DS3:GetAsync("online")
end)

game.Players.PlayerRemoving:Connect(function(plr)
	local liked = plr.Stats.Liked:GetChildren()
	local likedTable = {}

	for i, v in pairs(liked) do
		if v.Value then
			table.insert(likedTable, v.Name)
		end
	end

	DS2:SetAsync(tostring(plr.UserId).." Liked", likedTable)
	
	DS3:SetAsync("online", DS3:GetAsync("online")-1)
end)

RE_Update.OnServerEvent:Connect(function(plr, imageId, likes, unlike)
	if not(likes) then
		local liveCount = DS:GetAsync(tostring(imageId).." -Views")

		if liveCount then
			liveCount += 1
		else
			liveCount = 1
		end

		DS:SetAsync(tostring(imageId).." -Views", liveCount)
		RE_Update:FireClient(plr)
	else
		local liveLikeCount = DS:GetAsync(tostring(imageId).." -Likes")

		if not(unlike) then
			if liveLikeCount then
				liveLikeCount += 1
			else
				liveLikeCount = 1
			end
		else
			if liveLikeCount then
				liveLikeCount -= 1
			else
				liveLikeCount = 0
			end
		end
		
		if not(unlike) then
			local likeProof = Instance.new("BoolValue", plr:WaitForChild("Stats"):WaitForChild("Liked"))
			likeProof.Name = tostring(imageId)
			likeProof.Value = true
		else
			plr:WaitForChild("Stats"):WaitForChild("Liked"):FindFirstChild(tostring(imageId)):Destroy()
		end
		--[SAVING DATA]
		local likedTable = {}

		for i, v in pairs(plr.Stats.Liked:GetChildren()) do
			if v.Value then
				table.insert(likedTable, v.Name)
			end
		end

		DS2:SetAsync(tostring(plr.UserId).." Liked", likedTable)
			
		if liveLikeCount < 0 then
			liveLikeCount = 0
		end
			
		DS:SetAsync(tostring(imageId).." -Likes", liveLikeCount)
		RE_Update:FireClient(plr)
	end
end)

RE_GetData.OnServerEvent:Connect(function(plr, imageId)
	local viewCount = DS:GetAsync(tostring(imageId).." -Views")
	local likeCount = DS:GetAsync(tostring(imageId).." -Likes")
	local liked = false

	if plr:WaitForChild("Stats"):WaitForChild("Liked"):FindFirstChild(tostring(imageId)) then
		liked = true
	end

	if not(likeCount) then
		likeCount = 0
	end

	if not(viewCount) then
		viewCount = 0
	end

	RE_ReturnData:FireClient(plr, imageId, viewCount, likeCount, liked)
end)