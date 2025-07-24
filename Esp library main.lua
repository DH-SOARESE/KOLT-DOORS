--[[
Model ESP Library - Estilo HUB Modular
Autor: DH SOARES S.
Suporte: Nome, Distância, Tracer, Highlight Fill & Outline
Somente para objetos do tipo Model/BasePart
Corrigido por: ChatGPT
]]

local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local ModelESP = {}
ModelESP.Objects = {}
ModelESP.Enabled = true

local tracerOrigins = {
	Top = function(vs) return Vector2.new(vs.X / 2, 0) end,
	Center = function(vs) return Vector2.new(vs.X / 2, vs.Y / 2) end,
	Bottom = function(vs) return Vector2.new(vs.X / 2, vs.Y) end,
	Left = function(vs) return Vector2.new(0, vs.Y / 2) end,
	Right = function(vs) return Vector2.new(vs.X, vs.Y / 2) end,
}

local function getModelCenter(model)
	local total, count = Vector3.zero, 0
	for _, p in ipairs(model:GetDescendants()) do
		if p:IsA("BasePart") and p:IsDescendantOf(workspace) then
			total += p.Position
			count += 1
		end
	end
	if count == 0 then return nil end
	local center = total / count
	if center.Magnitude ~= center.Magnitude then return nil end -- NaN check
	return center
end

local function createDrawing(class, props)
	local obj = Drawing.new(class)
	for k, v in pairs(props) do obj[k] = v end
	return obj
end

function ModelESP:Add(target, config)
	if not target or not target:IsA("Instance") then return end

	local adornee = nil
	if target:IsA("Model") then
		adornee = target
		if not target.PrimaryPart then
			local primary = target:FindFirstChildWhichIsA("BasePart")
			if primary then target.PrimaryPart = primary end
		end
	elseif target:IsA("BasePart") then
		adornee = target
	else
		return
	end

	-- Remove highlights antigos
	for _, obj in pairs(target:GetChildren()) do
		if obj:IsA("Highlight") and obj.Name:match("^ESPHighlight") then obj:Destroy() end
	end

	local cfg = {
		Target = target,
		Color = config.Color or Color3.fromRGB(255, 255, 255),
		Name = config.Name or target.Name,
		ShowName = config.ShowName or false,
		ShowDistance = config.ShowDistance or false,
		Tracer = config.Tracer or false,
		HighlightFill = config.HighlightFill or false,
		HighlightOutline = config.HighlightOutline or false,
		TracerOrigin = config.TracerOrigin or "Bottom",
		MinDistance = config.MinDistance or 0,
		MaxDistance = config.MaxDistance or math.huge,
	}

	cfg.tracerLine = cfg.Tracer and createDrawing("Line", {
		Thickness = 1.5,
		Color = cfg.Color,
		Transparency = 1,
		Visible = false
	}) or nil

	cfg.nameText = cfg.ShowName and createDrawing("Text", {
		Text = cfg.Name,
		Color = cfg.Color,
		Size = 16,
		Center = true,
		Outline = true,
		Font = 2,
		Visible = false
	}) or nil

	cfg.distanceText = cfg.ShowDistance and createDrawing("Text", {
		Text = "",
		Color = cfg.Color,
		Size = 14,
		Center = true,
		Outline = true,
		Font = 2,
		Visible = false
	}) or nil

	cfg.highlightFill = cfg.HighlightFill and Instance.new("Highlight") or nil
	cfg.highlightOutline = cfg.HighlightOutline and Instance.new("Highlight") or nil

	if cfg.highlightFill then
		cfg.highlightFill.Name = "ESPHighlightFill"
		cfg.highlightFill.Adornee = adornee
		cfg.highlightFill.FillColor = cfg.Color
		cfg.highlightFill.FillTransparency = 0.6
		cfg.highlightFill.OutlineTransparency = 1
		cfg.highlightFill.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		cfg.highlightFill.Parent = workspace
	end

	if cfg.highlightOutline then
		cfg.highlightOutline.Name = "ESPHighlightOutline"
		cfg.highlightOutline.Adornee = adornee
		cfg.highlightOutline.FillTransparency = 1
		cfg.highlightOutline.OutlineColor = cfg.Color
		cfg.highlightOutline.OutlineTransparency = 0
		cfg.highlightOutline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		cfg.highlightOutline.Parent = workspace
	end

	table.insert(ModelESP.Objects, cfg)
end

function ModelESP:Remove(target)
	for i = #ModelESP.Objects, 1, -1 do
		local obj = ModelESP.Objects[i]
		if obj.Target == target then
			if obj.tracerLine then obj.tracerLine:Remove() end
			if obj.nameText then obj.nameText:Remove() end
			if obj.distanceText then obj.distanceText:Remove() end
			if obj.highlightFill then obj.highlightFill:Destroy() end
			if obj.highlightOutline then obj.highlightOutline:Destroy() end
			table.remove(ModelESP.Objects, i)
		end
	end
end

function ModelESP:Clear()
	for _, obj in ipairs(ModelESP.Objects) do
		if obj.tracerLine then obj.tracerLine:Remove() end
		if obj.nameText then obj.nameText:Remove() end
		if obj.distanceText then obj.distanceText:Remove() end
		if obj.highlightFill then obj.highlightFill:Destroy() end
		if obj.highlightOutline then obj.highlightOutline:Destroy() end
	end
	ModelESP.Objects = {}
end

RunService.RenderStepped:Connect(function()
	local vs = camera.ViewportSize

	for i = #ModelESP.Objects, 1, -1 do
		local esp = ModelESP.Objects[i]
		local target = esp.Target
		if not target or not target.Parent then
			ModelESP:Remove(target)
			continue
		end

		local pos3D = target:IsA("Model") and getModelCenter(target) or target.Position
		if not pos3D then continue end

		local success, pos2D = pcall(function()
			return camera:WorldToViewportPoint(pos3D)
		end)

		local onScreen = success and pos2D.Z > 0
		local distance = (camera.CFrame.Position - pos3D).Magnitude
		local visible = onScreen and distance >= esp.MinDistance and distance <= esp.MaxDistance

		-- Verificação adicional de posição inválida
		if not visible or pos2D.X ~= pos2D.X or pos2D.Y ~= pos2D.Y then
			if esp.tracerLine then esp.tracerLine.Visible = false end
			if esp.nameText then esp.nameText.Visible = false end
			if esp.distanceText then esp.distanceText.Visible = false end
			if esp.highlightFill then esp.highlightFill.Enabled = false end
			if esp.highlightOutline then esp.highlightOutline.Enabled = false end
			continue
		end

		-- Tracer
		if esp.tracerLine then
			esp.tracerLine.From = tracerOrigins[esp.TracerOrigin](vs)
			esp.tracerLine.To = Vector2.new(pos2D.X, pos2D.Y)
			esp.tracerLine.Visible = true
			esp.tracerLine.Color = esp.Color
		end

		-- Nome
		if esp.nameText then
			esp.nameText.Position = Vector2.new(pos2D.X, pos2D.Y - 20)
			esp.nameText.Visible = true
			esp.nameText.Text = esp.Name
			esp.nameText.Color = esp.Color
		end

		-- Distância
		if esp.distanceText then
			esp.distanceText.Position = Vector2.new(pos2D.X, pos2D.Y + 6)
			esp.distanceText.Visible = true
			esp.distanceText.Text = string.format("%.1fm", distance / 3.57)
			esp.distanceText.Color = esp.Color
		end

		-- Highlights
		if esp.highlightFill then
			esp.highlightFill.Enabled = true
			esp.highlightFill.FillColor = esp.Color
		end
		if esp.highlightOutline then
			esp.highlightOutline.Enabled = true
			esp.highlightOutline.OutlineColor = esp.Color
		end
	end
end)

return ModelESP
