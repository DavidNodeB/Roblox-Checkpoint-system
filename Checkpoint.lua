local Players = game:GetService("Players");
local CheckpointFolder = workspace.Checkpoints;
local DataStoreService = game:GetService("DataStoreService");
local dataStore = DataStoreService:GetDataStore("Name");

local function setup(player)
	local uid = player.UserId;
	local key = "Player_" .. uid;
	
	local leaderstats = Instance.new("Folder");
	leaderstats.Name = "leaderstats"; 
	
	local Checkpoint = Instance.new("IntValue");
	Checkpoint.Name = "Stage";
	
	local data = dataStore:GetAsync(key);
	
	Checkpoint.Value = data or 0;
	
	Checkpoint.Parent = leaderstats;
	leaderstats.Parent = player;
	player.CharacterAdded:Connect(function()
			if Checkpoint.Value > 0 then
				local char = player.Character;
			char.HumanoidRootPart.CFrame = CFrame.new(CheckpointFolder[Checkpoint.Value].Position) + Vector3.new(0, 4, 0)
			end
	end)
end

local function saveData(player)
	local uid = player.UserId;
	local key = "Player_" .. uid; 
	local leaderstats = player:FindFirstChild("leaderstats");
	
	if leaderstats then
		local CheckpointValue = leaderstats.Stage.Value;
		dataStore:SetAsync(key, CheckpointValue); 
	end
end

for i, checkpoint in pairs(CheckpointFolder:GetChildren()) do
	checkpoint.Touched:Connect(function(hit)
		local touched = hit.Parent;
		if touched:FindFirstChild("Humanoid") then
			local player = game.Players:GetPlayerFromCharacter(touched);
			local Checkpoint = player.leaderstats.Stage;
			if tonumber(checkpoint.Name) == Checkpoint.value + 1 then
				Checkpoint.Value += 1;
			end
		end
	end)
end

Players.PlayerAdded:Connect(setup);
Players.PlayerRemoving:Connect(saveData); 