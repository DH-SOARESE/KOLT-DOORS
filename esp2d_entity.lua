-- ESP 3D com desenho 2D: Esfera e Caixa 3D com cantos arredondados
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP3D = {}
local Connections = {}

local function ProjectPoint(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return onScreen, Vector2.new(screenPos.X, screenPos.Y), screenPos.Z
end

-- Desenha esfera 2D (círculo transparente com contorno)
local function CreateSphere(screenPos, radius, color)
	local circle = Drawing.new("Circle")
	circle.Position = screenPos
	circle.Radius = radius
	circle.Color = color or Color3.fromRGB(0, 255, 0)
	circle.Transparency = 0.3 -- Transparência
	circle.Thickness = 2
	circle.Filled = true
	circle.Visible = true
	return circle
end

-- Cria linhas para caixa 3D (com cantos arredondados no 2D)
local function CreateBox3D(points2D, color)
	local lines = {}

	local function newLine()
		local line = Drawing.new("Line")
		line.Color = color or Color3.new(1, 0, 0)
		line.Thickness = 2
		line.Visible = true
		return line
	end

	-- Liga os vértices para formar arestas do cubo
	-- Cubo tem 8 vértices (0 a 7)
	local edges = {
		{1,2},{2,3},{3,4},{4,1}, -- base inferior
		{5,6},{6,7},{7,8},{8,5}, -- base superior
		{1,5},{2,6},{3,7},{4,8}  -- liga base inferior com superior
	}

	for _, edge in pairs(edges) do
		local l = newLine()
		table.insert(lines, {line=l, from=edge[1], to=edge[2]})
	end

	local function update()
		for _, e in pairs(lines) do
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
	end

	return {
		lines = lines,
		Update = update,
		Remove = function()
			for _, e in pairs(lines) do
				e.line:Remove()
			end
		end
	}
end

-- Calcula os 8 vértices do cubo baseado na posição e tamanho
local function GetCubeVertices(pos, size)
	local hx, hy, hz = size.X/2, size.Y/2, size.Z/2
	local vertices = {
		pos + Vector3.new(-hx, -hy, -hz),
		pos + Vector3.new(hx, -hy, -hz),
		pos + Vector3.new(hx, -hy, hz),
		pos + Vector3.new(-hx, -hy, hz),

		pos + Vector3.new(-hx, hy, -hz),
		pos + Vector3.new(hx, hy, -hz),
		pos + Vector3.new(hx, hy, hz),
		pos + Vector3.new(-hx, hy, hz),
	}
	return vertices
end

-- Main add function
function ESP3D:Add(obj, config)
	config = config or {}
	if not obj then return end

	local size = config.Size or Vector3.new(4, 6, 2)
	local color = config.Color or Color3.fromRGB(0, 255, 0)

	-- Para esfera 2D desenhada
	local sphereCircle = Drawing.new("Circle")
	sphereCircle.Color = color
	sphereCircle.Thickness = 3
	sphereCircle.Filled = true
	sphereCircle.Transparency = 0.25
	sphereCircle.Visible = false

	local box3d

	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not obj or not obj:IsDescendantOf(workspace) then
			if box3d then box3d:Remove() end
			sphereCircle:Remove()
			conn:Disconnect()
			return
		end

		-- Pega posição principal do objeto (PrimaryPart ou Position)
		local pos
		if obj:IsA("Model") and obj.PrimaryPart then
			pos = obj.PrimaryPart.Position
		elseif obj:IsA("BasePart") then
			pos = obj.Position
		else
			pos = obj.Position or obj.CFrame.Position
		end

		-- Para esfera 2D
		local onScreen, screenPos, depth = ProjectPoint(pos)
		if onScreen then
			local scale = math.clamp(300 / depth, 5, 100) -- escala tamanho baseado na distância
			sphereCircle.Position = screenPos
			sphereCircle.Radius = scale
			sphereCircle.Visible = true
		else
			sphereCircle.Visible = false
		end

		-- Para cubo 3D desenhado
		local vertices3D = GetCubeVertices(pos, size)
		local points2D = {}
		local visibleAll = true
		for i, v in ipairs(vertices3D) do
			local vOnScreen, v2D = ProjectPoint(v)
			points2D[i] = v2D
			if not vOnScreen then visibleAll = false end
		end

		if not box3d then
			box3d = CreateBox3D(points2D, color)
		end

		box3d.Update()
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
