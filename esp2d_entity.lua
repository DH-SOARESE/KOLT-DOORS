--[[ 
Autor: DH SOARES
ESP orientada a objetos 2D (Sprites, UI)
Suporte: Tracer, Nome, Distância, Formas (Círculo, Quadrado, Retângulo)
Remoção individual, Toggle global
--]]

local ESP2D = {}
ESP2D.Enabled = true
ESP2D.Objects = {}
ESP2D.Drawings = {}
ESP2D.RunConnection = nil

local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer

local function Draw(type)
	return Drawing.new(type)
end

local function WorldToViewport(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return screenPos, onScreen
end

function ESP2D:Create(config)
	if not config or not config.Object then return end
	local objId = tostring(config.Object:GetDebugId())
	if ESP2D.Objects[objId] then return end

	local box = Draw(config.Form == "Circle" and "Circle" or "Square")
	box.Visible = false
	box.Color = config.Color or Color3.fromRGB(255, 255, 255)
	box.Thickness = 2
	box.Filled = false
	box.Radius = config.Form == "Circle" and 6 or nil
	box.Size = config.Form == "VerticalRect" and Vector2.new(4, 20) or Vector2.new(10,10)

	local tracer = Draw("Line")
	tracer.Visible = false
	tracer.Color = box.Color
	tracer.Thickness = 1

	local name = Draw("Text")
	name.Size = 13
	name.Center = true
	name.Outline = true
	name.Visible = false
	name.Color = box.Color

	local distance = Draw("Text")
	distance.Size = 13
	distance.Center = true
	distance.Outline = true
	distance.Visible = false
	distance.Color = box.Color

	ESP2D.Objects[objId] = {
		Object = config.Object,
		Form = config.Form or "Square",
		ShowTracer = config.Tracer ~= false,
		ShowName = config.Name ~= false,
		ShowDistance = config.Distance ~= false,
		Name = config.CustomName or config.Object.Name,
		Color = box.Color,
		Draws = {
			box = box,
			tracer = tracer,
			name = name,
			distance = distance
		}
	}
end

function ESP2D:Remove(object)
	local objId = tostring(object:GetDebugId())
	local data = ESP2D.Objects[objId]
	if data then
		for _, v in pairs(data.Draws) do
			v:Remove()
		end
		ESP2D.Objects[objId] = nil
	end
end

function ESP2D:Enable()
	ESP2D.Enabled = true
end

function ESP2D:Disable()
	ESP2D.Enabled = false
	for _, obj in pairs(ESP2D.Objects) do
		for _, d in pairs(obj.Draws) do
			d.Visible = false
		end
	end
end

function ESP2D:Clear()
	for _, obj in pairs(ESP2D.Objects) do
		for _, d in pairs(obj.Draws) do
			d:Remove()
		end
	end
	ESP2D.Objects = {}
end

ESP2D.RunConnection = game:GetService("RunService").RenderStepped:Connect(function()
	if not ESP2D.Enabled then return end
	for id, data in pairs(ESP2D.Objects) do
		local obj = data.Object
		if not obj or not obj:IsDescendantOf(workspace) then
			ESP2D:Remove(obj)
		else
			local pos = obj:IsA("Model") and obj:GetPivot().Position or obj.Position
			local screenPos, onScreen = WorldToViewport(pos)

			local draws = data.Draws
			if onScreen then
				local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude) or 0

				-- Box
				draws.box.Position = Vector2.new(screenPos.X, screenPos.Y)
				draws.box.Visible = true

				-- Tracer
				if data.ShowTracer then
					draws.tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
					draws.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
					draws.tracer.Visible = true
				else
					draws.tracer.Visible = false
				end

				-- Nome
				if data.ShowName then
					draws.name.Position = Vector2.new(screenPos.X, screenPos.Y - 18)
					draws.name.Text = data.Name
					draws.name.Visible = true
				else
					draws.name.Visible = false
				end

				-- Distância
				if data.ShowDistance then
					draws.distance.Position = Vector2.new(screenPos.X, screenPos.Y + 12)
					draws.distance.Text = "[" .. math.floor(dist) .. "m]"
					draws.distance.Visible = true
				else
					draws.distance.Visible = false
				end
			else
				for _, d in pairs(draws) do d.Visible = false end
			end
		end
	end
end)

return ESP2D
