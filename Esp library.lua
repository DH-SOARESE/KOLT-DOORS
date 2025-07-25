--[[
📦 Otimizado Model ESP Library
👤 DH SOARES (base) / Gemini (otimização)
--]]

local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local ModelESP = {Objects = {}, Enabled = true}

local tracerOrigins = {
	Top = function(vs) return Vector2.new(vs.X/2, 0) end,
	Center = function(vs) return Vector2.new(vs.X/2, vs.Y/2) end,
	Bottom = function(vs) return Vector2.new(vs.X/2, vs.Y) end,
	Left = function(vs) return Vector2.new(0, vs.Y/2) end,
	Right = function(vs) return Vector2.new(vs.X, vs.Y/2) end,
}

local function getModelCenter(model)
	if model.PrimaryPart then return model.PrimaryPart.Position end

	local total, count = Vector3.zero, 0
	for _, p in ipairs(model:GetDescendants()) do
		if p:IsA("BasePart") and p.CanCollide and p.Transparency < 1 then
			total += p.Position
			count += 1
		end
	end

	return count > 0 and total / count or nil
end

local function getModelExtents(model)
	local min, max = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)

	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local cf, size = part:GetBoundingBox()
			local corners = {
				cf * Vector3.new( size.X/2,  size.Y/2,  size.Z/2),
				cf * Vector3.new(-size.X/2,  size.Y/2,  size.Z/2),
				cf * Vector3.new( size.X/2, -size.Y/2,  size.Z/2),
				cf * Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
				cf * Vector3.new(-size.X/2, -size.Y/2,  size.Z/2),
				cf * Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
				cf * Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
				cf * Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
			}
			for _, c in ipairs(corners) do
				min = Vector3.new(math.min(min.X, c.X), math.min(min.Y, c.Y), math.min(min.Z, c.Z))
				max = Vector3.new(math.max(max.X, c.X), math.max(max.Y, c.Y), math.max(max.Z, c.Z))
			end
		end
	end

	return max - min
end

local function createDrawing(class, props)
	local obj = Drawing.new(class)
	for k, v in pairs(props) do obj[k] = v end
	return obj
end

function ModelESP:Add(target, config)
	if not target or not target:IsA("Instance") then return end

	local adornee = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart")) or target
	if not adornee then return end
	if target:IsA("Model") and not target.PrimaryPart then target.PrimaryPart = adornee end

	for _, c in ipairs(target:GetChildren()) do
		if c:IsA("Highlight") and c.Name:find("^ESP") then c:Destroy() end
	end

	local color = config.Color or Color3.new(1, 1, 1)
	local boxSize = config.BoxSize or (config.Show3DBox and getModelExtents(target))
	local dummyPart

	if boxSize then
		dummyPart = Instance.new("Part")
		dummyPart.Anchored = true
		dummyPart.CanCollide = false
		dummyPart.Transparency = 1
		dummyPart.Size = boxSize
		dummyPart.Parent = workspace
	end

	local obj = {
		Target = target,
		Color = color,
		Name = config.Name or target.Name,
		MinDistance = config.MinDistance or 0,
		MaxDistance = config.MaxDistance or math.huge,
		Tracer = config.Tracer and createDrawing("Line", {Thickness = 1.5, Transparency = 1, Visible = false}),
		ShowName = config.ShowName,
		ShowDistance = config.ShowDistance,
		NameText = config.ShowName and createDrawing("Text", {Size = 16, Center = true, Outline = true, Font = 2}),
		DistanceText = config.ShowDistance and createDrawing("Text", {Size = 14, Center = true, Outline = true, Font = 2}),
		TracerOrigin = config.TracerOrigin or "Bottom",
		HighlightFill = config.HighlightFill and Instance.new("Highlight"),
		HighlightOutline = config.HighlightOutline and Instance.new("Highlight"),
		Highlight3D = config.Show3DBox and Instance.new("Highlight"),
		DummyPart = dummyPart,
		BoxColor = config.BoxColor or color
	}

	if obj.HighlightFill then
		obj.HighlightFill.Name = "ESPHighlightFill"
		obj.HighlightFill.Adornee = adornee
		obj.HighlightFill.FillColor = color
		obj.HighlightFill.FillTransparency = 0.6
		obj.HighlightFill.OutlineTransparency = 1
		obj.HighlightFill.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		obj.HighlightFill.Parent = workspace
	end

	if obj.HighlightOutline then
		obj.HighlightOutline.Name = "ESPHighlightOutline"
		obj.HighlightOutline.Adornee = adornee
		obj.HighlightOutline.FillTransparency = 1
		obj.HighlightOutline.OutlineColor = color
		obj.HighlightOutline.OutlineTransparency = 0
		obj.HighlightOutline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		obj.HighlightOutline.Parent = workspace
	end

	if obj.Highlight3D and dummyPart then
		obj.Highlight3D.Name = "ESP3DBox"
		obj.Highlight3D.Adornee = dummyPart
		obj.Highlight3D.FillTransparency = 1
		obj.Highlight3D.OutlineColor = obj.BoxColor
		obj.Highlight3D.OutlineTransparency = 0
		obj.Highlight3D.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		obj.Highlight3D.Parent = workspace
	end

	table.insert(ModelESP.Objects, obj)
end

function ModelESP:Remove(target)
	for i = #self.Objects, 1, -1 do
		local obj = self.Objects[i]
		if obj.Target == target then
			if obj.Tracer then obj.Tracer:Remove() end
			if obj.NameText then obj.NameText:Remove() end
			if obj.DistanceText then obj.DistanceText:Remove() end
			if obj.HighlightFill then obj.HighlightFill:Destroy() end
			if obj.HighlightOutline then obj.HighlightOutline:Destroy() end
			if obj.Highlight3D then obj.Highlight3D:Destroy() end
			if obj.DummyPart then obj.DummyPart:Destroy() end
			table.remove(self.Objects, i)
		end
	end
end

function ModelESP:Clear()
	for _, obj in ipairs(self.Objects) do
		if obj.Tracer then obj.Tracer:Remove() end
		if obj.NameText then obj.NameText:Remove() end
		if obj.DistanceText then obj.DistanceText:Remove() end
		if obj.HighlightFill then obj.HighlightFill:Destroy() end
		if obj.HighlightOutline then obj.HighlightOutline:Destroy() end
		if obj.Highlight3D then obj.Highlight3D:Destroy() end
		if obj.DummyPart then obj.DummyPart:Destroy() end
	end
	self.Objects = {}
end

RunService.RenderStepped:Connect(function()
	local vs = camera.ViewportSize

	for _, esp in ipairs(ModelESP.Objects) do
		local target = esp.Target
		if not target or not target.Parent then
			ModelESP:Remove(target)
			continue
		end

		local pos = target:IsA("Model") and getModelCenter(target) or target.Position
		local ok, screenPos = pcall(camera.WorldToViewportPoint, camera, pos)
		local dist = (camera.CFrame.Position - pos).Magnitude
		local visible = ok and screenPos.Z > 0 and dist >= esp.MinDistance and dist <= esp.MaxDistance

		if not visible then
			if esp.Tracer then esp.Tracer.Visible = false end
			if esp.NameText then esp.NameText.Visible = false end
			if esp.DistanceText then esp.DistanceText.Visible = false end
			if esp.HighlightFill then esp.HighlightFill.Enabled = false end
			if esp.HighlightOutline then esp.HighlightOutline.Enabled = false end
			if esp.Highlight3D then esp.Highlight3D.Enabled = false end
			if esp.DummyPart then esp.DummyPart.Transparency = 1 end
			continue
		end

		local screenVec = Vector2.new(screenPos.X, screenPos.Y)

		if esp.Tracer then
			esp.Tracer.From = tracerOrigins[esp.TracerOrigin](vs)
			esp.Tracer.To = screenVec
			esp.Tracer.Color = esp.Color
			esp.Tracer.Visible = true
		end

		if esp.NameText then
			esp.NameText.Position = screenVec - Vector2.new(0, 20)
			esp.NameText.Text = esp.Name
			esp.NameText.Color = esp.Color
			esp.NameText.Visible = true
		end

		if esp.DistanceText then
			esp.DistanceText.Position = screenVec + Vector2.new(0, 6)
			esp.DistanceText.Text = string.format("%.1fm", dist / 3.57)
			esp.DistanceText.Color = esp.Color
			esp.DistanceText.Visible = true
		end

		if esp.HighlightFill then esp.HighlightFill.Enabled = true end
		if esp.HighlightOutline then esp.HighlightOutline.Enabled = true end

		if esp.Highlight3D and esp.DummyPart then
			local cf = target:IsA("Model") and target.PrimaryPart and target.PrimaryPart.CFrame or target.CFrame
			esp.DummyPart.CFrame = cf
			esp.DummyPart.Transparency = 0.999
			esp.Highlight3D.Enabled = true
		end
	end
end)

return ModelESP
