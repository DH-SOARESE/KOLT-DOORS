--[[
Autor: DH SOARES (modificado)
ESP orientada a objetos 2D com formas 3D simuladas
Formas: Esfera, Cubo, Capsula, Square
Linha (tracer) do topo da tela até o objeto
Contorno com cor mais forte para destaque
--]]

local ESP2D = {}
ESP2D.Enabled = true
ESP2D.Objects = {}

local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local function Draw(type)
	return Drawing.new(type)
end

local function WorldToViewport(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return screenPos, onScreen
end

-- Helper pra desenhar contorno de retângulo arredondado
local function DrawRoundedRectOutline(position, size, thickness, color, radius)
	local segments = 10
	local pts = {}

	-- Calcula pontos dos cantos arredondados
	for i = 0, segments do
		local theta = math.pi/2 * (i / segments)
		table.insert(pts, Vector2.new(position.X + radius - radius*math.cos(theta), position.Y + radius - radius*math.sin(theta))) -- top-left
		table.insert(pts, Vector2.new(position.X + size.X - radius + radius*math.cos(theta), position.Y + radius - radius*math.sin(theta))) -- top-right
		table.insert(pts, Vector2.new(position.X + radius - radius*math.cos(theta), position.Y + size.Y - radius + radius*math.sin(theta))) -- bottom-left
		table.insert(pts, Vector2.new(position.X + size.X - radius + radius*math.cos(theta), position.Y + size.Y - radius + radius*math.sin(theta))) -- bottom-right
	end

	for i = 1, #pts - 1 do
		local line = Draw("Line")
		line.From = pts[i]
		line.To = pts[i + 1]
		line.Color = color
		line.Thickness = thickness
		line.Visible = true
		task.delay(0.03, function() line:Remove() end)
	end
end

function ESP2D:Create(config)
	if not config or not config.Object then return end
	local objId = tostring(config.Object:GetDebugId())
	if ESP2D.Objects[objId] then return end

	local form = config.Form or "Square"
	local color = config.Color or Color3.fromRGB(255, 255, 255)

	-- Box principal
	local boxType = (form == "Esfera" or form == "Capsula") and "Circle" or "Square"
	local box = Draw(boxType)
	box.Visible = false
	box.Color = color
	box.Thickness = 2
	box.Filled = (form ~= "Square") -- preenche para dar efeito sólido nas formas 3D simuladas
	box.Radius = (form == "Esfera" or form == "Capsula") and 10 or nil

	-- Contorno mais forte para destaque
	local outline = Draw(boxType)
	outline.Visible = false
	outline.Color = Color3.new(math.clamp(color.R * 0.5,0,1), math.clamp(color.G * 0.5,0,1), math.clamp(color.B * 0.5,0,1)) -- cor mais escura
	outline.Thickness = 4
	outline.Filled = false
	outline.Radius = box.Radius

	local tracer = Draw("Line")
	tracer.Visible = false
	tracer.Color = color
	tracer.Thickness = 1

	local name = Draw("Text")
	name.Size = 13
	name.Center = true
	name.Outline = true
	name.Visible = false
	name.Color = color

	local distance = Draw("Text")
	distance.Size = 13
	distance.Center = true
	distance.Outline = true
	distance.Visible = false
	distance.Color = color

	ESP2D.Objects[objId] = {
		Object = config.Object,
		Form = form,
		ShowTracer = config.Tracer ~= false,
		ShowName = config.Name ~= false,
		ShowDistance = config.Distance ~= false,
		Name = config.CustomName or config.Object.Name,
		Color = color,
		Draws = {
			box = box,
			outline = outline,
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

RunService.RenderStepped:Connect(function()
	if not ESP2D.Enabled then return end
	for id, data in pairs(ESP2D.Objects) do
		local obj = data.Object
		if not obj or not obj:IsDescendantOf(workspace) then
			ESP2D:Remove(obj)
		else
			local pos, size
			if obj:IsA("Model") then
				local cf, s = obj:GetBoundingBox()
				pos = cf.Position
				size = s
			elseif obj:IsA("BasePart") then
				pos = obj.Position
				size = obj.Size
			else
				continue
			end

			local screenPos, onScreen = WorldToViewport(pos)
			local draws = data.Draws
			if onScreen then
				local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude) or 0

				local scale = 1 / (Camera.CFrame.Position - pos).Magnitude * 100

				local size2D

				-- Ajusta tamanho e forma baseado no tipo
				if data.Form == "Esfera" then
					size2D = Vector2.new(size.X * scale, size.X * scale)
					draws.box.Radius = size2D.X/2
					draws.outline.Radius = size2D.X/2
				elseif data.Form == "Capsula" then
					size2D = Vector2.new(size.X * scale * 0.6, size.Y * scale)
					draws.box.Radius = size2D.X/2
					draws.outline.Radius = size2D.X/2
				elseif data.Form == "Cubo" then
					size2D = Vector2.new(math.max(size.X, size.Y) * scale, math.max(size.X, size.Y) * scale)
					draws.box.Radius = 6
					draws.outline.Radius = 6
				else -- Square
					size2D = Vector2.new(size.X * scale, size.Y * scale)
					draws.box.Radius = nil
					draws.outline.Radius = nil
				end

				-- Posiciona contorno primeiro (maior e mais grosso)
				draws.outline.Position = Vector2.new(screenPos.X - size2D.X/2, screenPos.Y - size2D.Y/2)
				draws.outline.Size = size2D
				draws.outline.Visible = true

				-- Posiciona box (fill mais suave por cima)
				draws.box.Position = Vector2.new(screenPos.X - size2D.X/2, screenPos.Y - size2D.Y/2)
				draws.box.Size = size2D
				draws.box.Visible = true

				-- Linha do topo da tela até o centro do objeto
				if data.ShowTracer then
					draws.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
					draws.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
					draws.tracer.Visible = true
				else
					draws.tracer.Visible = false
				end

				-- Nome
				if data.ShowName then
					draws.name.Position = Vector2.new(screenPos.X, screenPos.Y - size2D.Y/2 - 15)
					draws.name.Text = data.Name
					draws.name.Visible = true
				else
					draws.name.Visible = false
				end

				-- Distância
				if data.ShowDistance then
					draws.distance.Position = Vector2.new(screenPos.X, screenPos.Y + size2D.Y/2 + 2)
					draws.distance.Text = "[" .. math.floor(dist) .. "m]"
					draws.distance.Visible = true
				else
					draws.distance.Visible = false
				end

			else
				for _, d in pairs(draws) do
					d.Visible = false
				end
			end
		end
	end
end)

return ESP2D
