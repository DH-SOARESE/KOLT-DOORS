--[[ 
Autor: DH SOARES
ESP 2D com formas que simulam aparência 3D
Suporte: Nome, Distância, Tracer, Formas (Esfera, Cubo, Cápsula)
Orientado a Model ou BasePart
]]

local ESP2D = {}
ESP2D.Drawings = {}
ESP2D.Enabled = true

local camera = workspace.CurrentCamera
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

local function createDrawing(cls, props)
	local obj = Drawing.new(cls)
	for i, v in pairs(props) do
		obj[i] = v
	end
	return obj
end

local function getPosition(obj)
	if obj:IsA("Model") then
		local cf, size = obj:GetBoundingBox()
		return cf.Position
	elseif obj:IsA("BasePart") then
		return obj.Position
	end
end

local function createESP(obj, cfg)
	local box = createDrawing("Square", {
		Thickness = 2,
		Filled = true,
		Color = cfg.Color or Color3.new(1, 0, 0),
		Transparency = 0.6,
		Visible = false,
		ZIndex = 2
	})

	local outline = createDrawing("Square", {
		Thickness = 4,
		Filled = false,
		Color = Color3.new(0, 0, 0),
		Transparency = 1,
		Visible = false,
		ZIndex = 1
	})

	local tracer = createDrawing("Line", {
		Color = cfg.Color or Color3.new(1, 1, 1),
		Transparency = 0.6,
		Thickness = 2,
		Visible = false,
		ZIndex = 2
	})

	local name = createDrawing("Text", {
		Color = Color3.new(1, 1, 1),
		Size = 14,
		Center = true,
		Outline = true,
		Visible = false,
		ZIndex = 3
	})

	local distance = createDrawing("Text", {
		Color = Color3.new(1, 1, 1),
		Size = 13,
		Center = true,
		Outline = true,
		Visible = false,
		ZIndex = 3
	})

	ESP2D.Drawings[obj] = {box = box, outline = outline, tracer = tracer, name = name, distance = distance, cfg = cfg}
end

function ESP2D:Remove(obj)
	local esp = ESP2D.Drawings[obj]
	if esp then
		for _, v in pairs(esp) do
			if typeof(v) == "table" and v.Remove then
				v:Remove()
			end
		end
		ESP2D.Drawings[obj] = nil
	end
end

function ESP2D:Create(cfg)
	assert(cfg.Object and typeof(cfg.Object) == "Instance", "Object inválido")
	createESP(cfg.Object, cfg)
end

rs.RenderStepped:Connect(function()
	if not ESP2D.Enabled then return end
	for obj, esp in pairs(ESP2D.Drawings) do
		if not obj or not obj.Parent then
			ESP2D:Remove(obj)
			continue
		end

		local pos = getPosition(obj)
		local screenPos, onScreen = camera:WorldToViewportPoint(pos)
		if not onScreen then
			for _, v in pairs(esp) do
				if typeof(v) == "table" and v.Visible ~= nil then
					v.Visible = false
				end
			end
			continue
		end

		local cfg = esp.cfg
		local sizeFactor = math.clamp((camera.CFrame.Position - pos).Magnitude / 30, 1.2, 4)

		-- Desenhar formas diferentes
		local size = Vector2.new(20, 20) * sizeFactor
		if cfg.Form == "Esfera" then
			esp.box.Size = size
			esp.box.Position = screenPos - size / 2
			esp.box.Radius = math.floor(size.X / 2)
			esp.box.Filled = true
			esp.box.Visible = true
		elseif cfg.Form == "Cubo" then
			esp.box.Size = size
			esp.box.Position = screenPos - size / 2
			esp.box.Visible = true
		elseif cfg.Form == "Capsula" then
			esp.box.Size = Vector2.new(size.X * 0.6, size.Y * 1.2)
			esp.box.Position = screenPos - esp.box.Size / 2
			esp.box.Visible = true
		else -- Square padrão
			esp.box.Size = size
			esp.box.Position = screenPos - size / 2
			esp.box.Visible = true
		end

		-- Outline
		esp.outline.Size = esp.box.Size
		esp.outline.Position = esp.box.Position
		esp.outline.Visible = true

		-- Nome
		if cfg.Name then
			esp.name.Text = cfg.CustomName or obj.Name
			esp.name.Position = screenPos - Vector2.new(0, size.Y / 2 + 16)
			esp.name.Visible = true
		else
			esp.name.Visible = false
		end

		-- Distância
		if cfg.Distance then
			local dist = (camera.CFrame.Position - pos).Magnitude
			esp.distance.Text = "[" .. math.floor(dist) .. "m]"
			esp.distance.Position = screenPos + Vector2.new(0, size.Y / 2 + 2)
			esp.distance.Visible = true
		else
			esp.distance.Visible = false
		end

		-- Tracer
		if cfg.Tracer then
			esp.tracer.From = Vector2.new(camera.ViewportSize.X / 2, 0)
			esp.tracer.To = screenPos
			esp.tracer.Visible = true
		else
			esp.tracer.Visible = false
		end
	end
end)

return ESP2D
