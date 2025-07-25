--[[
Autor: DH SOARES
ESP orientada a objetos 3D (Highlight e Adornments)
Suporte: Tracer 2D do topo da tela, Nome, Distância, Formas 3D (Esfera, Cubo, Cápsula)
--]]

local ESP3D = {}
ESP3D.Enabled = true
ESP3D.Objects = {}
ESP3D.RunConnection = nil

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function ESP3D:Create(config)
	if not config or not config.Object then return end
	local objId = tostring(config.Object:GetDebugId())
	if ESP3D.Objects[objId] then return end

	local obj = config.Object
	local part = obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart") or obj
	if not part then return end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = config.Color or Color3.fromRGB(255, 255, 255)
	highlight.OutlineColor = (config.Color and config.Color:lerp(Color3.new(1, 1, 1), -0.5)) or Color3.new(1, 1, 1)
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = true
	highlight.Adornee = obj
	highlight.Parent = game.CoreGui

	local adornment
	local form = config.Form3D or "Sphere"
	if form == "Sphere" then
		adornment = Instance.new("SphereHandleAdornment")
	elseif form == "Box" then
		adornment = Instance.new("BoxHandleAdornment")
	elseif form == "Capsule" then
		adornment = Instance.new("CylinderHandleAdornment")
	else
		form = "Sphere"
		adornment = Instance.new("SphereHandleAdornment")
	end

	adornment.Radius = 2
	adornment.Size = Vector3.new(4, 4, 4)
	adornment.Adornee = part
	adornment.AlwaysOnTop = true
	adornment.ZIndex = 1
	adornment.Color3 = config.Color or Color3.fromRGB(255, 255, 255)
	adornment.Transparency = 0.4
	adornment.Name = "ESPAdornment"
	adornment.Parent = game.CoreGui

	local tracer = Drawing.new("Line")
	tracer.Thickness = 2
	tracer.Color = adornment.Color3
	tracer.Visible = false

	local name = Drawing.new("Text")
	name.Size = 13
	name.Center = true
	name.Outline = true
	name.Visible = false
	name.Color = adornment.Color3

	local distance = Drawing.new("Text")
	distance.Size = 13
	distance.Center = true
	distance.Outline = true
	distance.Visible = false
	distance.Color = adornment.Color3

	ESP3D.Objects[objId] = {
		Object = obj,
		Part = part,
		Name = config.CustomName or obj.Name,
		ShowTracer = config.Tracer ~= false,
		ShowName = config.Name ~= false,
		ShowDistance = config.Distance ~= false,
		Draws = {
			highlight = highlight,
			adornment = adornment,
			tracer = tracer,
			name = name,
			distance = distance,
		}
	}
end

function ESP3D:Remove(object)
	local objId = tostring(object:GetDebugId())
	local data = ESP3D.Objects[objId]
	if data then
		for _, d in pairs(data.Draws) do
			if typeof(d) == "Instance" then
				pcall(function() d:Destroy() end)
			else
				d:Remove()
			end
		end
		ESP3D.Objects[objId] = nil
	end
end

function ESP3D:Enable()
	ESP3D.Enabled = true
end

function ESP3D:Disable()
	ESP3D.Enabled = false
	for _, data in pairs(ESP3D.Objects) do
		for _, d in pairs(data.Draws) do
			if typeof(d) ~= "Instance" then
				d.Visible = false
			elseif d:IsA("Highlight") then
				d.Enabled = false
			end
		end
	end
end

function ESP3D:Clear()
	for _, data in pairs(ESP3D.Objects) do
		for _, d in pairs(data.Draws) do
			if typeof(d) == "Instance" then
				pcall(function() d:Destroy() end)
			else
				d:Remove()
			end
		end
	end
	ESP3D.Objects = {}
end

ESP3D.RunConnection = game:GetService("RunService").RenderStepped:Connect(function()
	if not ESP3D.Enabled then return end

	for id, data in pairs(ESP3D.Objects) do
		local obj = data.Object
		local part = data.Part
		if not obj or not part or not obj:IsDescendantOf(workspace) then
			ESP3D:Remove(obj)
		else
			local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
			local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude) or 0
			local draws = data.Draws

			if data.ShowTracer and onScreen then
				draws.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
				draws.tracer.To = Vector2.new(screenPos.X, screenPos.Y)
				draws.tracer.Visible = true
			else
				draws.tracer.Visible = false
			end

			if data.ShowName and onScreen then
				draws.name.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
				draws.name.Text = data.Name
				draws.name.Visible = true
			else
				draws.name.Visible = false
			end

			if data.ShowDistance and onScreen then
				draws.distance.Position = Vector2.new(screenPos.X, screenPos.Y + 12)
				draws.distance.Text = "[" .. math.floor(dist) .. "m]"
				draws.distance.Visible = true
			else
				draws.distance.Visible = false
			end
		end
	end
end)

return ESP3D
