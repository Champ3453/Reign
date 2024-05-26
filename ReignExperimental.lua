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
			Callback = callback;
		})
	end

	if Data.OnKeypress then
		local key = Data.OnKeypress.Key;
		local callback = Data.OnKeypress.Callback;

		Reign:OnKeypress({
			Key = key;
			Callback = callback;
		})
	end

	if Data.Transition then
		local time = Data.Transition.Time;
		local style = Data.Transition.EasingStyle or Data.Transition.Style;
		local direction = Data.Transition.EasingDirection or Data.Transition.Direction;
		local properties = Data.Transition.Properties or Data.Transition.Props;
		local play = Data.Transition.Play or false;

		Reign:Transition({
			Instance = instance;
			Time = time;
			Style = style;
			Direction = direction;
			Properties = properties;
			Play = play;
		});
	end

	if Data.OnHover then
		local callback = Data.OnHover.Callback;

		Reign:OnHover({
			Instance = instance;
			Callback = callback;
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
			Callback = callback;
		})
	end

	if Data.Transition then
		local time = Data.Transition.Time;
		local style = Data.Transition.EasingStyle or Data.Transition.Style;
		local direction = Data.Transition.EasingDirection or Data.Transition.Direction;
		local properties = Data.Transition.Properties or Data.Transition.Props;
		local play = Data.Transition.Play or false;

		Reign:Transition({
			Instance = instance;
			Time = time;
			Style = style;
			Direction = direction;
			Properties = properties;
			Play = play;
		});
	end

	return instance;
end

function Reign:OnKeydown(Data)
	local key = Data.Key;
	local callback = Data.Callback;

	local state;
	
	local startThread;
	local endThread;
	local ended;

	return game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end;
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end;
		
		if input.KeyCode == Enum.KeyCode[key] then
				startThread = task.spawn(function()
				state = true;
				callback(state);
			end)
		end;
		
		ended = input.Changed:Connect(function(prop)
			if prop == "UserInputState" then
				if input.UserInputState == Enum.UserInputState.End then
					if input.KeyCode == Enum.KeyCode[key] then
						state = false;
						task.cancel(startThread);
						endThread = task.spawn(function()
							state = false;
							callback(state);
						end);
						task.cancel(endThread);
						ended:Disconnect();
					end
				end
			end
		end);
	end)
end

function Reign:OnKeypress(Data)
	local key = Data.Key;
	local callback = Data.Callback;
	local state = false;

	return game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end;
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end;
		
		if input.KeyCode == Enum.KeyCode[key] then
			state = not state;
			callback(state);
		end;
	end);
end;

function Reign:Transition(Data)
	local instance = Data.Instance;
	local time = Data.Time;
	local es = Data.EasingStyle or Data.Style;
	local ed = Data.EasingDirection or Data.Direction;
	local properties = Data.Properties or Data.Props;
	local play = Data.Play or false;

	if play then
		return game:GetService("TweenService"):Create(instance, TweenInfo.new(time, Enum.EasingStyle[es], Enum.EasingDirection[ed]), properties):Play();
	else
		return game:GetService("TweenService"):Create(instance, TweenInfo.new(time, Enum.EasingStyle[es], Enum.EasingDirection[ed]), properties);
	end
end

function Reign:OnHover(Data)
	local instance = Data.Instance;
	local callback = Data.Callback;
	local state;

	instance.MouseEnter:Connect(function()
		state = true;
		callback(state);
	end);

	instance.MouseLeave:Connect(function()
		state = false;
		callback(state);
	end)
end

return Reign;
