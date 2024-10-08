-- // Constants \\ --
local MAX_LINEAR_VELOCITY = 800 -- ZwiÃ„â„¢kszam maksymalnÃ„â€¦ prÃ„â„¢dkoÃ…â€ºÃ„â€¡ liniowÃ„â€¦, przy ktÃƒÂ³rej postaÃ„â€¡ zostanie zatrzymana
local MAX_ANGULAR_VELOCITY = 800 -- ZwiÃ„â„¢kszam maksymalnÃ„â€¦ prÃ„â„¢dkoÃ…â€ºÃ„â€¡ kÃ„â€¦towÃ„â€¦, przy ktÃƒÂ³rej postaÃ„â€¡ zostanie zatrzymana

-- [ Services ] --
local Services = setmetatable({}, {__index = function(Self, Index)
    local NewService = game:GetService(Index)
    if NewService then
        Self[Index] = NewService
    end
    return NewService
end})

-- [ LocalPlayer ] --
local LocalPlayer = Services.Players.LocalPlayer

-- // Functions \\ --
local function PlayerAdded(Player)
    local Detected = false
    local Character;
    local PrimaryPart;

    local function CharacterAdded(NewCharacter)
        Character = NewCharacter
        repeat
            wait()
            PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
        until PrimaryPart
        Detected = false
    end

    CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
    Player.CharacterAdded:Connect(CharacterAdded)
    Services.RunService.Heartbeat:Connect(function()
        if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
            if PrimaryPart.AssemblyAngularVelocity.Magnitude > MAX_ANGULAR_VELOCITY or PrimaryPart.AssemblyLinearVelocity.Magnitude > MAX_LINEAR_VELOCITY then
                if Detected == false then

                end
                Detected = true
                for i,v in ipairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                        v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                    end
                end
                PrimaryPart.CanCollide = false
                PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
            end
        end
    end)
end

-- // Event Listeners \\ --
for i,v in ipairs(Services.Players:GetPlayers()) do
    if v ~= LocalPlayer then
        PlayerAdded(v)
    end
end
Services.Players.PlayerAdded:Connect(PlayerAdded)

local LastPosition = nil
Services.RunService.Heartbeat:Connect(function()
    pcall(function()
        local PrimaryPart = LocalPlayer.Character.PrimaryPart
        if PrimaryPart.AssemblyLinearVelocity.Magnitude > MAX_LINEAR_VELOCITY or PrimaryPart.AssemblyAngularVelocity.Magnitude > MAX_ANGULAR_VELOCITY then
            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            PrimaryPart.CFrame = LastPosition
        elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
            LastPosition = PrimaryPart.CFrame
        end
    end)
end)
