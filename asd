
getgenv().settings = { 
    Enabled = true,
    Hitbox = 'Head', 
    TeamCheckEnabled = false, 
    Smoothness = 0.20016,
    FOVRadius = 150, 
    fovs = true,
    
}

--// Variables
local Players = game:GetService('Players') 
local RunService = game:GetService('RunService') 
local UserInputService = game:GetService('UserInputService')

local LocalPlayer = Players.LocalPlayer 
local CurrentCamera = workspace.CurrentCamera

local Storage = {} 
local FOV = Drawing.new('Circle') 

do 
    FOV.Visible = settings.fovs

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            FOV.Position = UserInputService:GetMouseLocation()
        end
    end)

    FOV.Thickness = 2
    FOV.Color = Color3.new(255, 128, 128)
end

RunService.PostSimulation:Connect(function() 

    local MousePosition = UserInputService:GetMouseLocation() 
    Storage.Target = nil 
    Storage.TargetDistance = settings.FOVRadius
    FOV.Radius = settings.FOVRadius 
 FOV.Visible = settings.fovs
 
 for i, player in next, Players:GetChildren() do 

    local Humanoid = player.Character and player.Character:FindFirstChildWhichIsA('Humanoid') 
    local HumanoidRootPart = player.Character and player.Character:FindFirstChild('HumanoidRootPart') 

    if not Humanoid or not HumanoidRootPart or player == LocalPlayer then 
        continue
    end

    if settings.TeamCheckEnabled and player.Team == LocalPlayer.Team then
        continue
    end

    if Humanoid.Health <= 0 then 
        continue
    end



        local ScreenPosition, ScreenVisible = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position) 
        ScreenPosition = Vector2.new(ScreenPosition.X, ScreenPosition.Y) 
        local MouseDistance = (MousePosition - ScreenPosition).magnitude 

        if not ScreenVisible then 
            continue
        end

        if MouseDistance < Storage.TargetDistance then 
            Storage.Target = player 
            Storage.TargetDistance = MouseDistance
        end
    end

    if Storage.Target ~= nil then
        local HitPart = Storage.Target.Character:FindFirstChild(settings.Hitbox) 

        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and settings.Enabled then 
    local TargetPartPosition = CurrentCamera:WorldToViewportPoint(HitPart.Position) 
    local RelativeMousePosition = Vector2.new(TargetPartPosition.X, TargetPartPosition.Y) - MousePosition 

    mousemoverel(RelativeMousePosition.X * settings.Smoothness, RelativeMousePosition.Y * settings.Smoothness) 
end
    end
end)
