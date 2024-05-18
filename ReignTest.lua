local Reign = {};

-- Functions
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
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end;
            if input.KeyCode == Enum.KeyCode[Data.OnKeydown.Key] then
                task.spawn(Data.OnKeydown.Callback);
            end
        end)
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
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end;
            if input.KeyCode == Enum.KeyCode[Data.OnKeydown.Key] then
                task.spawn(Data.OnKeydown.Callback)
            end
        end)
    end

    return instance;
end

return Reign;
