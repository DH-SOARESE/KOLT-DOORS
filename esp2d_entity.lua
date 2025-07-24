--[[
📦 ESP3D - Desenho 3D projetado em 2D
Autor: DH SOARES
Descrição: ESP que desenha Esfera (círculo 2D transparente) ou Caixa 3D projetada em 2D com opção de cantos arredondados.
Configurações:
- Mode = "Sphere" | "Box"
- Size = Vector3 (apenas para Box)
- Color = Color3
- Transparency = 0 a 1
- RoundedCorners = true/false (só para Box)
]]

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP3D = {}
local Connections = {}

-- Projeta ponto 3D para tela 2D, retorna visibilidade, posição e profundidade
local function ProjectPoint(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return onScreen, Vector2.new(screenPos.X, screenPos.Y), screenPos.Z
end

-- Cria círculo Drawing
local function CreateCircle()
	local circle = Drawing.new("Circle")
	circle.Filled = true
	circle.Thickness = 3
	circle.Visible = false
	return circle
end

-- Cria linhas para a caixa 3D
local function CreateBoxLines(color)
	local lines = {}

	local function newLine()
		local l = Drawing.new("Line")
		l.Color = color
		l.Thickness = 2
		l.Visible = false
		return l
	end

	-- Aretes do cubo (vértices numerados 1 a 8)
	local edges = {
		{1,2},{2,3},{3,4},{4,1}, -- base inferior
		{5,6},{6,7},{7,8},{8,5}, -- base superior
		{1,5},{2,6},{3,7},{4,8}  -- conexões verticais
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

-- Desenha arco simples entre 2 pontos (aproximado)
local function DrawArc(fromPos, toPos, segments, radius, color)
	segments = segments or 5
	local lines = {}

	local function newLine()
		local l = Drawing.new("Line")
		l.Color = color
		l.Thickness = 2
		l.Visible = true
		return l
	end

	for i = 1, segments do
		lines[i] = newLine()
	end

	-- calcula pontos interpolados em arco
	local function interpolatePoints(p1, p2, t)
		-- curva quadrática simples: p(t) = (1 - t)^2 * p1 + 2(1 - t)t * midpoint + t^2 * p2
		-- pra simplicidade aqui só interp linear (arredondar direito é mais complexo)
		return p1:Lerp(p2, t)
	end

	-- atualizar linhas baseado na interpolação linear (aproxima curva)
	local function update()
		for i = 1, segments do
			local t1 = (i - 1) / segments
			local t2 = i / segments
			local pStart = interpolatePoints(fromPos, toPos, t1)
			local pEnd = interpolatePoints(fromPos, toPos, t2)
			lines[i].From = pStart
			lines[i].To = pEnd
			lines[i].Visible = true
		end
	end

	update()

	return {
		lines = lines,
		Update = update,
		Remove = function()
			for _, l in pairs(lines) do
				l:Remove()
			end
		end
	}
end

-- Função principal para adicionar ESP
function ESP3D:Add(obj, config)
	config = config or {}
	if not obj then return end

	local mode = config.Mode or "Sphere" -- "Sphere" ou "Box"
	local size = config.Size or Vector3.new(4, 6, 2)
	local color = config.Color or Color3.fromRGB(0, 255, 0)
	local transparency = config.Transparency or 0.3
	local rounded = config.RoundedCorners or false

	local circle
	local box3d
	local arcs = {}

	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not obj or not obj:IsDescendantOf(workspace) then
			if circle then circle:Remove() end
			if box3d then box3d:Remove() end
			for _, arc in pairs(arcs) do arc:Remove() end
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

		if mode == "Sphere" then
			-- Desenha esfera 2D como círculo com transparência
			if not circle then
				circle = CreateCircle()
			end

			if onScreen then
				local scale = math.clamp(300 / depth, 5, 100)
				circle.Position = screenPos
				circle.Radius = scale
				circle.Color = color
				circle.Transparency = transparency
				circle.Visible = true
			else
				circle.Visible = false
			end

		elseif mode == "Box" then
			-- Desenha caixa 3D projetada em 2D
			local vertices = GetCubeVertices(pos, size)
			local points2D = {}
			local allOnScreen = true
			for i, v in ipairs(vertices) do
				local vOnScreen, v2D = ProjectPoint(v)
				points2D[i] = v2D
				if not vOnScreen then allOnScreen = false end
			end

			if not box3d then
				box3d = CreateBoxLines(color)
			end

			box3d.Update(points2D)

			-- Desenha cantos arredondados (simples, só substitui algumas linhas por arcos)
			if rounded then
				-- Remove linhas para desenhar arcos
				for _, e in ipairs(box3d.lines) do
					e.line.Visible = false
				end
				-- Exemplo: desenhar arco simples entre os cantos da base inferior (1-2, 2-3, 3-4, 4-1)
				-- Para simplicidade, só 4 arcos base
				if #arcs == 0 then
					arcs[1] = DrawArc(points2D[1], points2D[2], 6, 5, color)
					arcs[2] = DrawArc(points2D[2], points2D[3], 6, 5, color)
					arcs[3] = DrawArc(points2D[3], points2D[4], 6, 5, color)
					arcs[4] = DrawArc(points2D[4], points2D[1], 6, 5, color)
				else
					for i=1,4 do
						-- Atualiza posição dos arcos
						for segIndex, lineSeg in ipairs(arcs[i].lines) do
							local t1 = (segIndex - 1) / 6
							local t2 = segIndex / 6
							lineSeg.From = points2D[arcs[i].lines[segIndex].From] or points2D[1]
							lineSeg.To = points2D[arcs[i].lines[segIndex].To] or points2D[2]
						end
					end
				end
			else
				-- Remove arcos se existirem
				for _, arc in pairs(arcs) do
					arc:Remove()
				end
				arcs = {}
			end

			if not onScreen then
				for _, e in ipairs(box3d.lines) do
					e.line.Visible = false
				end
				if circle then circle.Visible = false end
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
