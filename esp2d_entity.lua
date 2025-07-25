--[[  
ESP 2D Library (UI) - by DH SOARES  
Melhorias:  
✅ Formas: Circle, Square, VerticalRect  
✅ Tracer, Nome, Distância  
✅ Atualização por Heartbeat  
✅ Remoção individual e global  
✅ Toggle geral  
--]]  

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local ESP = {
	Enabled = true,
	Instances = {},
}

local function createESPItem(obj, config)
	local part = obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") or obj
	if not part or not part:IsA("BasePart") then return end

	local folder = Instance.new("Folder")
	folder.Name = "ESP2D_Item"
	folder.Parent = game:GetService("CoreGui")

	local function createGui(form)
		local gui = Instance.new("BillboardGui")
		gui.AlwaysOnTop = true
		gui.Size = UDim2.new(0, 100, 0, 100)
		gui.Adornee = part
		gui.Parent = folder

		local shape = Instance.new("Frame")
		shape.AnchorPoint = Vector2.new(0.5, 0.5)
		shape.Position = UDim2.new(0.5, 0, 0.5, 0)
		shape.BackgroundTransparency = config.Transparency or 0.5
		shape.BorderSizePixel = 0
		shape.BackgroundColor3 = config.Color or Color3.new(1, 1, 1)
		shape.Size = UDim2.new(0, 25, 0, 25)
		shape.Name = "Shape"
		shape.ZIndex = 2
		shape.Parent = gui

		if form == "Circle" then
			local uicorner = Instance.new("UICorner")
			uicorner.CornerRadius = UDim.new(1, 0)
			uicorner.Parent = shape
		elseif form == "VerticalRect" then
			shape.Size = UDim2.new(0, 10, 0, 50)
		end

		return gui
	end

	local gui = createGui(config.Form or "Circle")

	if config.Name then
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Text = config.CustomName or obj.Name
		nameLabel.Size = UDim2.new(0, 200, 0, 20)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.TextStrokeTransparency = 0.5
		nameLabel.TextScaled = true
		nameLabel.Position = UDim2.new(0.5, -100, 0, -20)
		nameLabel.AnchorPoint = Vector2.new(0.5, 1)
		nameLabel.ZIndex = 3
		nameLabel.Parent = gui
	end

	if config.Distance then
		local distLabel = Instance.new("TextLabel")
		distLabel.Name = "DistLabel"
		distLabel.Size = UDim2.new(0, 200, 0, 20)
		distLabel.BackgroundTransparency = 1
		distLabel.TextColor3 = Color3.new(0.7, 1, 0.7)
		distLabel.TextScaled = true
		distLabel.Position = UDim2.new(0.5, -100, 1, 0)
		distLabel.AnchorPoint = Vector2.new(0.5, 0)
		distLabel.ZIndex = 3
		distLabel.Parent = gui
	end

	if config.Tracer then
		local line = Drawing.new("Line")
		line.Thickness = 1.5
		line.Color = config.Color or Color3.fromRGB(255, 0, 0)
		line.Transparency = 1
		line.ZIndex = 1

		gui:GetPropertyChangedSignal("Parent"):Connect(function()
			if not gui:IsDescendantOf(game) then
				line:Remove()
			end
		end)

		ESP.Instances[obj] = {Gui = gui, Line = line, Config = config, Obj = obj}
	else
		ESP.Instances[obj] = {Gui = gui, Line = nil, Config = config, Obj = obj}
	end

	obj.AncestryChanged:Connect(function(_, parent)
		if not parent then
			ESP.Remove(obj)
		end
	end)
end

function ESP:Add(obj, config)
	if not obj or ESP.Instances[obj] then return end
	createESPItem(obj, config)
end

function ESP:Remove(obj)
	if ESP.Instances[obj] then
		local info = ESP.Instances[obj]
		if info.Gui then
			info.Gui:Destroy()
		end
		if info.Line then
			info.Line:Remove()
		end
		ESP.Instances[obj] = nil
	end
end

function ESP:Clear()
	for obj in pairs(ESP.Instances) do
		self:Remove(obj)
	end
end

function ESP:Toggle(state)
	ESP.Enabled = state
end

RunService.RenderStepped:Connect(function()
	if not ESP.Enabled then return end

	for obj, info in pairs(ESP.Instances) do
		local part = obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") or obj
		if not part or not part:IsDescendantOf(workspace) then
			ESP:Remove(obj)
			continue
		end

		if info.Gui and info.Gui:FindFirstChild("DistLabel") then
			local player = Players.LocalPlayer
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local dist = (char.HumanoidRootPart.Position - part.Position).Magnitude
				info.Gui.DistLabel.Text = string.format("[%.1f]", dist)
			end
		end

		if info.Line then
			local screenPos1, visible1 = Camera:WorldToViewportPoint(part.Position)
			local screenPos2, visible2 = Camera:WorldToViewportPoint(Camera.CFrame.Position)

			info.Line.Visible = visible1 and visible2
			if visible1 and visible2 then
				info.Line.From = Vector2.new(screenPos2.X, screenPos2.Y)
				info.Line.To = Vector2.new(screenPos1.X, screenPos1.Y)
			end
		end
	end
end)

return ESP
