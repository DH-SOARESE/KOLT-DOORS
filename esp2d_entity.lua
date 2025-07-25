--[[ 
    Autor: DH SOARES (editado)
    ESP com formas 3D reais (Esfera, Cubo, Cápsula, Square)
    Tracer do topo da tela até o modelo
    Contorno com cor mais forte
--]]

local ESP3D = {}
ESP3D.Enabled = true
ESP3D.Objects = {}

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateAdornment(form, adornee, color, size)
	local adorn
	if form == "Esfera" then
		adorn = Instance.new("SphereHandleAdornment")
	elseif form == "Cubo" or form == "Square" then
		adorn = Instance.new("BoxHandleAdornment")
	elseif form == "Cápsula" or form == "Capsula" then
		adorn = Instance.new("CylinderHandleAdornment")
	else
		adorn = Instance.new("BoxHandleAdornment")
	end

	adorn.Adornee = adornee
	adorn.AlwaysOnTop = true
	adorn.ZIndex = 5
	adorn.Color3 = color
	adorn.Transparency = 0.3
	adorn.Size = size
	adorn.Name = "ESP3D_Visual"
	adorn.Parent = CoreGui
	adorn.Visible = true

	-- Contorno (mais forte)
	local outline = adorn:Clone()
	outline.ZIndex = 4
	outline.Transparency = 0
	outline.Color3 = color:lerp(Color3.new(1, 1, 1), -0.5)
	outline.Size = size * 1.05
	outline.Parent = CoreGui

	return adorn, outline
end

function ESP3D:Create(config)
	if not config or not config.Object then return end
	local object = config.Object
	local objId = tostring(object:GetDebugId())
	if ESP3D.Objects[objId] then return end

	local color = config.Color or Color3.fromRGB(255, 255, 255)
	local form = config.Form or "Cubo"

	local adornee
	if object:IsA("Model") then
		object.PrimaryPart = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
		if not object.PrimaryPart then return end
		adornee = object.PrimaryPart
	elseif object:IsA("BasePart") then
		adornee = object
	else
		return
	end

	local _, size = object:IsA("Model") and object:GetBoundingBox() or {nil, adornee.Size}
	local adorn, outline = CreateAdornment(form, adornee, color, size)

	ESP3D.Objects[objId] = {
		Object = object,
		Adornment = adorn,
		Outline = outline,
		ShowTracer = config.Tracer ~= false,
		Color = color
	}
end

function ESP3D:Remove(object)
	local objId = tostring(object:GetDebugId())
	local data = ESP3D.Objects[objId]
	if data then
		if data.Adornment then data.Adornment:Destroy() end
		if data.Outline then data.Outline:Destroy() end
		if data.TracerLine then data.TracerLine:Remove() end
		ESP3D.Objects[objId] = nil
	end
end

function ESP3D:Clear()
	for _, data in pairs(ESP3D.Objects) do
		if data.Adornment then data.Adornment:Destroy() end
		if data.Outline then data.Outline:Destroy() end
		if data.TracerLine then data.TracerLine:Remove() end
	end
	ESP3D.Objects = {}
end

function ESP3D:Enable()
	ESP3D.Enabled = true
end

function ESP3D:Disable()
	ESP3D.Enabled = false
	for _, data in pairs(ESP3D.Objects) do
		if data.Adornment then data.Adornment.Visible = false end
		if data.Outline then data.Outline.Visible = false end
		if data.TracerLine then data.TracerLine.Visible = false end
	end
end

-- Atualização visual
RunService.RenderStepped:Connect(function()
	if not ESP3D.Enabled then return end

	for id, data in pairs(ESP3D.Objects) do
		local obj = data.Object
		if not obj or not obj:IsDescendantOf(workspace) then
			ESP3D:Remove(obj)
		else
			if data.Adornment then data.Adornment.Visible = true end
			if data.Outline then data.Outline.Visible = true end

			if data.ShowTracer then
				local root = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
				if root then
					local worldPos = root.Position
					local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)

					if not data.TracerLine then
						local line = Drawing.new("Line")
						line.Thickness = 2
						line.Color = data.Color
						line.Transparency = 1
						data.TracerLine = line
					end

					local tracer = data.TracerLine
					if onScreen then
						tracer.From = Vector2.new(screenPos.X, 0) -- topo da tela
						tracer.To = Vector2.new(screenPos.X, screenPos.Y)
						tracer.Visible = true
					else
						tracer.Visible = false
					end
				end
			elseif data.TracerLine then
				data.TracerLine.Visible = false
			end
		end
	end
end)

return ESP3D
