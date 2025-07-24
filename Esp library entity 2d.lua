-- ESP Entity 2D Library (DH Edition)
local ESP2D = {}

local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

ESP2D.Entities = {} -- [Instance] = {Color=Color3, Shape="Quadrado"}
ESP2D.Enabled = true
ESP2D.DefaultShape = "Quadrado" -- "Círculo", "Quadrado", "Arredondado"

local Drawings = {} -- cache de desenhos

local function WorldToScreen(pos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
	return Vector2.new(screenPos.X, screenPos.Y), onScreen
end

local function CreateDrawings()
	return {
		Box = Drawing.new("Square"),
		Circle = Drawing.new("Circle"),
		Line = Drawing.new("Line")
	}
end

local function UpdateDrawings(draws, playerScreenPos, entScreenPos, size2D, color, shape)
	-- Linha
	draws.Line.Visible = true
	draws.Line.From = playerScreenPos
	draws.Line.To = entScreenPos
	draws.Line.Color = color
	draws.Line.Thickness = 2

	if shape == "Círculo" then
		draws.Circle.Visible = true
		draws.Circle.Position = entScreenPos
		draws.Circle.Radius = size2D.X / 2
		draws.Circle.Color = color
		draws.Circle.Thickness = 2
		draws.Circle.NumSides = 30
		draws.Circle.Filled = false
		draws.Box.Visible = false
	elseif shape == "Arredondado" then
		draws.Box.Visible = true
		draws.Box.Position = Vector2.new(entScreenPos.X - size2D.X / 2, entScreenPos.Y - size2D.Y / 2)
		draws.Box.Size = Vector2.new(size2D.X, size2D.Y * 0.9) -- simula arredondamento vertical
		draws.Box.Color = color
		draws.Box.Filled = false
		draws.Box.Thickness = 2
		draws.Circle.Visible = false
	else -- Quadrado
		draws.Box.Visible = true
		draws.Box.Position = Vector2.new(entScreenPos.X - size2D.X / 2, entScreenPos.Y - size2D.Y / 2)
		draws.Box.Size = size2D
		draws.Box.Color = color
		draws.Box.Filled = false
		draws.Box.Thickness = 2
		draws.Circle.Visible = false
	end
end

function ESP2D:Add(entity, color, shape)
	if not entity:IsA("Model") then return end
	if self.Entities[entity] then return end

	self.Entities[entity] = {
		Color = color or Color3.fromRGB(255,255,255),
		Shape = shape or ESP2D.DefaultShape
	}
	Drawings[entity] = CreateDrawings()
end

function ESP2D:Remove(entity)
	if Drawings[entity] then
		for _,v in pairs(Drawings[entity]) do
			v:Remove()
		end
	end
	Drawings[entity] = nil
	self.Entities[entity] = nil
end

function ESP2D:Clear()
	for ent in pairs(self.Entities) do
		self:Remove(ent)
	end
end

function ESP2D:SetShapeForAll(shape)
	for _,v in pairs(self.Entities) do
		v.Shape = shape
	end
end

RunService.RenderStepped:Connect(function()
	if not ESP2D.Enabled then
		for _,d in pairs(Drawings) do
			for _,v in pairs(d) do
				v.Visible = false
			end
		end
		return
	end

	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local playerScreenPos, playerVisible = WorldToScreen(hrp.Position)
	if not playerVisible then return end

	for ent, data in pairs(ESP2D.Entities) do
		if ent and ent.Parent then
			local cf, size = ent:GetBoundingBox()
			local entScreenPos, onScreen = WorldToScreen(cf.Position)
			if onScreen then
				local size2D = Vector2.new(size.X * 15, size.Y * 15) -- escala 2D
				UpdateDrawings(Drawings[ent], playerScreenPos, entScreenPos, size2D, data.Color, data.Shape)
			else
				for _,v in pairs(Drawings[ent]) do
					v.Visible = false
				end
			end
		else
			ESP2D:Remove(ent)
		end
	end
end)

return ESP2D
