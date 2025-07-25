--[[ 
Autor: DH SOARES
ESP orientada a objetos 2D (Sprites, UI)
Suporte: Tracer, Nome, Distância, Formas (Círculo, Quadrado, Retângulo Vertical)
Orientado para Model e BasePart
Remoção individual, Toggle global
--]]

local ESP2D = {}
ESP2D.Enabled = true
ESP2D.Objects = {}
ESP2D.Drawings = {}

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
	local obj = config.Object
	local objId = tostring(obj:GetDebugId())
	if ESP2D.Objects[objId] then return end

	-- Criar as formas (desenhos)
	local box = Draw(config.Form == "Circle" and "Circle" or "Square")
	box.Visible = false
	box.Color = config.Color or Color3.fromRGB(255, 255, 255)
	box.Thickness = 2
	box.Filled = false
	box.Radius = config.Form == "Circle" and 6 or nil
	box.Size = config.Form == "VerticalRect" and Vector2.new(4, 20) or Vector2.new(10, 10)

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
		Object = obj,
		Form = config.Form or "Square",
		ShowTracer = config.Tracer ~= false,
		ShowName = config.Name ~= false,
		ShowDistance = config.Distance ~= false,
		Name = config.CustomName or obj.Name,
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
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	for id, data in pairs(ESP2D.Objects) do
		local obj = data.Object
		if not obj or not obj:IsDescendantOf(workspace) then
			ESP2D:Remove(obj)
		else
			-- Para Model, pegar o Pivot, senão pegar Position direto
			local pos
			if obj:IsA("Model") then
				-- Se o modelo não tem pivot, tenta pegar a PrimaryPart
				if pcall(function() pos = obj:GetPivot().Position end) then
					-- OK, pos atribuída
				elseif obj.PrimaryPart then
					pos = obj.PrimaryPart.Position
				else
					pos = nil
				end
			elseif obj:IsA("BasePart") then
				pos = obj.Position
			end

			if pos then
				local screenPos, onScreen = WorldToViewport(pos)

				local draws = data.Draws
				if onScreen then
					local dist = hrp and (hrp.Position - pos).Magnitude or 0

					-- Box (Posição centralizada)
					draws.box.Position = Vector2.new(screenPos.X, screenPos.Y)
					draws.box.Visible = true

					-- Tracer (linha da base da tela até o objeto)
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
			else
				-- Sem posição válida, esconde tudo
				for _, d in pairs(data.Draws) do
					d.Visible = false
				end
			end
		end
	end
end)

return ESP2D
