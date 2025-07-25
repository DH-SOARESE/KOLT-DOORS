--[[  
ESP 2D com formas 3D simuladas e Highlight real  
Autor: DH SOARES (adaptado para loadstring)  
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

function ESP2D:Create(config)
	if not config or not config.Object then return end
	local objId = tostring(config.Object:GetDebugId())
	if ESP2D.Objects[objId] then return end

	local form = config.Form or "Square"
	local color = config.Color or Color3.fromRGB(255, 255, 255)

	local box = Draw(form:find("Sphere") and "Circle" or "Square")
	box.Visible = false
	box.Color = color
	box.Thickness = 2
	box.Filled = form:find("3D") and true or false
	box.Radius = form == "3DSphere" and 8 or nil

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

	local highlight
	if config.Highlight3D then
		highlight = Instance.new("Highlight")
		highlight.Name = "ESP_Highlight"
		highlight.FillTransparency = 1
		highlight.OutlineColor = color
		highlight.OutlineTransparency = 0
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = config.Object
		highlight.Adornee = config.Object
	end

	ESP2D.Objects[objId] = {
		Object = config.Object,
		Form = form,
		ShowTracer = config.Tracer ~= false,
		ShowName = config.Name ~= false,
		ShowDistance = config.Distance ~= false,
		Name = config.CustomName or config.Object.Name,
		Color = color,
		Highlight = highlight,
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
		if data.Highlight then
			data.Highlight:Destroy()
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
		if obj.Highlight then
			obj.Highlight:Destroy()
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
				local size2D = Vector2.new(size.X * scale, size.Y * scale)

				if data.Form == "VerticalRect" or data.Form == "3DRect" then
					size2D = Vector2.new(6, size2D.Y + 20)
				elseif data.Form == "3DSphere" then
					draws.box.Radius = size2D.Y / 2
				elseif data.Form == "3DCube" then
					-- Simula cantos arredondados aproximando um quadrado maior
					size2D = Vector2.new(math.max(size2D.X, size2D.Y), math.max(size2D.X, size2D.Y))
				end

				draws.box.Size = size2D
				draws.box.Position = Vector2.new(screenPos.X - size2D.X / 2, screenPos.Y - size2D.Y / 2)
				draws.box.Visible = true

				draws.box.Filled = data.Form:find("3D") ~= nil
				draws.box.Transparency = 0.15
				draws.box.Thickness = 2

				if data.ShowTracer then
					draws.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
					draws.tracer.To = screenPos
					draws.tracer.Visible = true
				else
					draws.tracer.Visible = false
				end

				if data.ShowName then
					draws.name.Position = Vector2.new(screenPos.X, screenPos.Y - size2D.Y / 2 - 15)
					draws.name.Text = data.Name
					draws.name.Visible = true
				else
					draws.name.Visible = false
				end

				if data.ShowDistance then
					draws.distance.Position = Vector2.new(screenPos.X, screenPos.Y + size2D.Y / 2 + 2)
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
