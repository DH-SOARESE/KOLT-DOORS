--[[
📦 ESP3D - Desenho 3D projetado em 2D com linha pontilhada e toggles
Autor: DH SOARES
Configurações principais:
- Mode = "Sphere" | "Box"
- Size = Vector3 (apenas Box)
- Color = Color3
- Transparency = 0 a 1
- RoundedCorners = true/false (Box)
- Tracer = true/false
- Box = true/false
]]

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP3D = {}
local Connections = {}

-- Projeta ponto 3D para 2D e retorna visibilidade e profundidade
local function ProjectPoint(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return onScreen, Vector2.new(screenPos.X, screenPos.Y), screenPos.Z
end

-- Cria círculo Drawing (para esfera 2D)
local function CreateCircle()
	local circle = Drawing.new("Circle")
	circle.Filled = true
	circle.Thickness = 3
	circle.Visible = false
	return circle
end

-- Cria linha simples Drawing
local function CreateLine()
	local line = Drawing.new("Line")
	line.Visible = false
	line.Thickness = 2
	return line
end

-- Cria linhas pontilhadas para tracer (linha pontilhada)
local function CreateDashedLine()
	local segments = {}
	local segmentCount = 8
	for i = 1, segmentCount do
		local segment = Drawing.new("Line")
		segment.Thickness = 2
		segment.Transparency = 1
		segment.Visible = false
		table.insert(segments, segment)
	end
	return segments
end

-- Atualiza linha pontilhada entre dois pontos
local function UpdateDashedLine(segments, from, to)
	local dashLength = 1 / #segments
	local dir = (to - from)
	for i, segment in ipairs(segments) do
		local t0 = (i-1) * dashLength
		local t1 = i * dashLength
		local p0 = from + dir * t0
		local p1 = from + dir * t1
		segment.From = p0
		segment.To = p1
		segment.Visible = true
	end
end

-- Cria linhas para caixa 3D
local function CreateBoxLines(color)
	local lines = {}

	local function newLine()
		local l = Drawing.new("Line")
		l.Color = color
		l.Thickness = 2
		l.Visible = false
		return l
	end

	local edges = {
		{1,2},{2,3},{3,4},{4,1},
		{5,6},{6,7},{7,8},{8,5},
		{1,5},{2,6},{3,7},{4,8}
	}

	for _, edge in ipairs(edges) do
		table.insert(lines, {line=newLine(), from=edge[1], to=edge[2]})
	end

	return {
		lines = lines,
		Update = function(points2D)
			for _, e in ipairs(lines) do
				local p1 = points2D[e.from]
				local p2 = points2D[e.to]
				if p1 and p2 then
					e.line.From = p1
					e.line.To = p2
					e.line.Visible = true
				else
					e.line.Visible = false
				end
			end
		end,
		Remove = function()
			for _, e in ipairs(lines) do
				e.line:Remove()
			end
		end
	}
end

-- Calcula os 8 vértices do cubo baseado na posição e tamanho
local function GetCubeVertices(pos, size)
	local hx, hy, hz = size.X / 2, size.Y / 2, size.Z / 2
	return {
		pos + Vector3.new(-hx, -hy, -hz),
		pos + Vector3.new(hx, -hy, -hz),
		pos + Vector3.new(hx, -hy, hz),
		pos + Vector3.new(-hx, -hy, hz),
		pos + Vector3.new(-hx, hy, -hz),
		pos + Vector3.new(hx, hy, -hz),
		pos + Vector3.new(hx, hy, hz),
		pos + Vector3.new(-hx, hy, hz),
	}
end

function ESP3D:Add(obj, config)
	config = config or {}
	if not obj then return end

	local mode = config.Mode or "Sphere" -- "Sphere" ou "Box"
	local size = config.Size or Vector3.new(4, 6, 2)
	local color = config.Color or Color3.fromRGB(0, 255, 0)
	local transparency = config.Transparency or 0.3
	local rounded = config.RoundedCorners or false
	local tracerEnabled = (config.Tracer == nil) and true or config.Tracer
	local boxEnabled = (config.Box == nil) and true or config.Box

	local circle
	local box3d
	local arcs = {}

	-- Cria tracer linha pontilhada
	local tracerSegments
	local function createTracer()
		if tracerSegments then
			for _, seg in ipairs(tracerSegments) do seg.Visible = false seg:Remove() end
		end
		tracerSegments = CreateDashedLine()
		for _, seg in ipairs(tracerSegments) do
			seg.Color = color
			seg.Transparency = transparency
		end
	end

	createTracer()

	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not obj or not obj:IsDescendantOf(workspace) then
			if circle then circle:Remove() end
			if box3d then box3d:Remove() end
			if tracerSegments then
				for _, seg in ipairs(tracerSegments) do
					seg.Visible = false
					seg:Remove()
				end
			end
			conn:Disconnect()
			return
		end

		local pos
		if obj:IsA("Model") and obj.PrimaryPart then
			pos = obj.PrimaryPart.Position
		elseif obj:IsA("BasePart") then
			pos = obj.Position
		else
			pos = obj.Position or obj.CFrame.Position
		end

		local onScreen, screenPos, depth = ProjectPoint(pos)
		local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

		-- Desenha tracer (linha pontilhada) se habilitado
		if tracerEnabled then
			if onScreen then
				UpdateDashedLine(tracerSegments, screenCenter, screenPos)
				for _, seg in ipairs(tracerSegments) do seg.Visible = true end
			else
				for _, seg in ipairs(tracerSegments) do seg.Visible = false end
			end
		else
			for _, seg in ipairs(tracerSegments) do seg.Visible = false end
		end

		if mode == "Sphere" and boxEnabled then
			if not circle then
				circle = CreateCircle()
			end

			if onScreen and boxEnabled then
				local scale = math.clamp(300 / depth, 5, 100)
				circle.Position = screenPos
				circle.Radius = scale
				circle.Color = color
				circle.Transparency = transparency
				circle.Visible = true
			else
				circle.Visible = false
			end

			if box3d then
				box3d:Remove()
				box3d = nil
			end

		elseif mode == "Box" and boxEnabled then
			local vertices = GetCubeVertices(pos, size)
			local points2D = {}
			for i, v in ipairs(vertices) do
				local vOnScreen, v2D = ProjectPoint(v)
				points2D[i] = v2D
			end

			if not box3d then
				box3d = CreateBoxLines(color)
			end
			box3d.Update(points2D)

			if circle then
				circle.Visible = false
			end
		else
			if circle then circle.Visible = false end
			if box3d then
				box3d:Remove()
				box3d = nil
			end
		end
	end)

	table.insert(Connections, conn)
end

function ESP3D:Clear()
	for _, c in ipairs(Connections) do
		c:Disconnect()
	end
	Connections = {}
end

return ESP3D
