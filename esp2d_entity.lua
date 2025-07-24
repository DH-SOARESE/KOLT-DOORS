--[[  
📦 ESP 2D LIBRARY (Image Entity Tracker)
Autor: DH SOARES  
Suporte: Line (tracer), Box (formato adaptativo)
Orientado a endereço de objetos tipo ImageLabel, Decal, BillboardGui ou modelos planos
]]

local ESP2D = {}
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local Connections = {}

local function IsOnScreen(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return onScreen, screenPos
end

local function CreateLine()
	local line = Drawing.new("Line")
	line.Thickness = 2
	line.Color = Color3.fromRGB(255, 255, 0)
	line.Visible = false
	return line
end

local function CreateBox()
	local box = Drawing.new("Square")
	box.Thickness = 1.5
	box.Color = Color3.fromRGB(255, 0, 0)
	box.Filled = false
	box.Visible = false
	return box
end

function ESP2D:Add(obj, config)
	config = config or {}
	if not obj or not obj:IsA("Instance") then return end

	local tracer = CreateLine()
	local box = CreateBox()

	local con = RunService.RenderStepped:Connect(function()
		if not obj or not obj:IsDescendantOf(workspace) then
			tracer:Remove()
			box:Remove()
			con:Disconnect()
			return
		end

		local rootPos = obj:IsA("Model") and obj:GetPivot().Position or (obj.Position or obj.CFrame.Position)
		local onScreen, screenPos = IsOnScreen(rootPos)

		if onScreen then
			local viewCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
			tracer.From = viewCenter
			tracer.To = Vector2.new(screenPos.X, screenPos.Y)
			tracer.Visible = config.Tracer ~= false

			-- Box dimensions baseados no tipo
			local size = config.Size or Vector2.new(30, 50)
			if config.Shape == "Circle" then
				box.Visible = false
			else
				box.Position = Vector2.new(screenPos.X - size.X/2, screenPos.Y - size.Y/2)
				box.Size = size
				box.Visible = config.Box ~= false
			end
		else
			tracer.Visible = false
			box.Visible = false
		end
	end)

	table.insert(Connections, con)
end

function ESP2D:Clear()
	for _, c in ipairs(Connections) do
		c:Disconnect()
	end
	Connections = {}
end

return ESP2D
