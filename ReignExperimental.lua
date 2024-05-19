local Reign = {};

function Reign:Make(Data)
	local instance = Instance.new(Data.Instance);

	if Data.Properties then
		for prop, value in Data.Properties do
			instance[prop] = value;
		end
	end

	if Data.Attributes then
		for attr, value in Data.Attributes do
			instance:SetAttribute(attr, value);
		end
	end

	if Data.Tags then
		for value in Data.Tags do
			instance:AddTag(value);
		end
	end

	if instance:IsA("TextButton") or instance:IsA("ImageButton") then
		if Data.OnClick then
			instance[Data.OnClick.Button]:Connect(Data.OnClick.Callback);
		end
	end
	
	if Data.OnKeydown then
		local key = Data.OnKeydown.Key;
		local callback = Data.OnKeydown.Callback;

		Reign:OnKeydown({
			Key = key;
			Callback = callback
		})
	end

	return instance;
end

function Reign:Update(Data)
	local instance = Data.Instance;

	if Data.Properties then
		for prop, value in Data.Properties do
			instance[prop] = value;
		end
	end

	if Data.Attributes then
		for attr, value in Data.Attributes do
			instance:SetAttribute(attr, value);
		end
	end

	if Data.Tags then
		for tag, value in Data.Tags do
			instance:RemoveTag(tag);
			instance:AddTag(value);
		end
	end

	if instance:IsA("TextButton") or instance:IsA("ImageButton") then
		if Data.OnClick then
			instance[Data.OnClick.Button]:Connect(Data.OnClick.Callback);
		end
	end
	
	if Data.OnKeydown then
		local key = Data.OnKeydown.Key;
		local callback = Data.OnKeydown.Callback;

		Reign:OnKeydown({
			Key = key;
			Callback = callback
		})
	end

	return instance;
end

function Reign:OnKeydown(Data)
	local key = Data.Key;
	local callback = Data.Callback;
	
	local state;
	local thread;

	game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end;
		if input.KeyCode == Enum.KeyCode[key] then
			thread = task.spawn(function()
				state = true;
				callback(state);
			end)
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end;
		if input.KeyCode == Enum.KeyCode[key] then
			state = false;
			callback(state);
			task.cancel(thread);
		end
	end)
end

return Reign;
