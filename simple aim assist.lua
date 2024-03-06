local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- The part of the character you want to aim at (e.g. Head, Torso, etc.)
local AimPart = "Head"

-- The maximum distance for the aim assist to search for targets
local MaxDistance = 50

-- The sensitivity of the aim assist (higher values will make the aim assist more sensitive)
local Sensitivity = 10

-- A function that gets the closest enemy player within the maximum distance
local function GetClosestEnemy()
	local closestPlayer
	local shortestDistance = MaxDistance

	for i, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			for _, character in ipairs(player.Character:GetChildren()) do
				if character:FindFirstChild(AimPart) then
					local part = character[AimPart]
					local distance = (Camera.CFrame.p - part.CFrame.p).Magnitude

					if distance < shortestDistance then
						shortestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
	end

	return closestPlayer
end

-- A function that moves the player's camera to aim at the enemy
local function AimAtEnemy()
	local enemy = GetClosestEnemy()

	if enemy then
		local aimPart = enemy.Character:FindFirstChild(AimPart)

		if aimPart then
			local lookVector = (aimPart.Position - Camera.CFrame.p).Unit
			local newCFrame = Camera.CFrame * CFrame.new(0, 0, -MaxDistance) * CFrame.lookAt(lookVector)

			Camera.CFrame = newCFrame
		end
	end
end

-- A function that checks if the user is holding down the left mouse button
local function IsMouseButtonDown()
	local inputState, input = UserInputService:GetMouseState()

	return inputState and input.UserInputType == Enum.UserInputType.MouseButton1
end

-- A function that moves the camera to aim at the enemy when the user holds down the left mouse button
RunService:BindToRenderStep("AimAssist", Enum.RenderPriority.Camera.Value - 1, function()
	if IsMouseButtonDown() then
		AimAtEnemy()
	end
end)

-- A function that smooths the movement of the camera
local function SmoothCamera()
	local smoothness = Sensitivity * RunService.RenderStepped:Wait()

	local cameraPosition = Camera.CFrame.p
	local lookVector = Camera.CFrame.LookVector

	local newCameraPosition = cameraPosition + lookVector * smoothness

	Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, -(cameraPosition - newCameraPosition).Magnitude)
end

-- A function that checks if the user is holding down the left mouse button
RunService:BindToRenderStep("SmoothCamera", Enum.RenderPriority.Camera.Value - 2, SmoothCamera)



-- Made by Project Ellernate.