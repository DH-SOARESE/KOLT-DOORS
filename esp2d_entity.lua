--[[ 
    ESP 3D Visual - Versão Orientada a Endereço (Model/BasePart)
    Suporte: Box (Cubo), Sphere, Linha
    Autor: DH SOARES
--]]

local ESP3D = {
    Objects = {},
    Enabled = true,
    Defaults = {
        Form = "Box", -- "Box" ou "Sphere"
        Color = Color3.fromRGB(0, 255, 100),
        Transparency = 0.5,
        Material = Enum.Material.Neon,
        ShowLine = true
    }
}

local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer

-- Cria um cubo 3D
local function createBox(position, color, transparency, material)
    local box = Instance.new("Part")
    box.Size = Vector3.new(2, 2, 2)
    box.Position = position
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = transparency
    box.Material = material
    box.Color = color
    box.Name = "ESP_Box"
    box.Parent = workspace
    return box
end

-- Cria uma esfera 3D
local function createSphere(position, color, transparency, material)
    local sphere = Instance.new("Part")
    sphere.Shape = Enum.PartType.Ball
    sphere.Size = Vector3.new(2.5, 2.5, 2.5)
    sphere.Position = position
    sphere.Anchored = true
    sphere.CanCollide = false
    sphere.Transparency = transparency
    sphere.Material = material
    sphere.Color = color
    sphere.Name = "ESP_Sphere"
    sphere.Parent = workspace
    return sphere
end

-- Cria uma linha 3D (Beam)
local function createLine(origin, target, color)
    local a1 = Instance.new("Attachment", origin)
    local a2 = Instance.new("Attachment", target)

    local beam = Instance.new("Beam")
    beam.Attachment0 = a1
    beam.Attachment1 = a2
    beam.Width0 = 0.08
    beam.Width1 = 0.08
    beam.Color = ColorSequence.new(color)
    beam.FaceCamera = true
    beam.LightEmission = 1
    beam.Name = "ESP_Line"
    beam.Parent = origin

    return beam
end

-- Adiciona ESP ao objeto
function ESP3D:Add(obj, config)
    config = config or {}
    local form = config.Form or self.Defaults.Form
    local color = config.Color or self.Defaults.Color
    local transparency = config.Transparency or self.Defaults.Transparency
    local material = config.Material or self.Defaults.Material
    local showLine = config.ShowLine ~= false

    local part
    if form == "Box" then
        part = createBox(obj.Position, color, transparency, material)
    elseif form == "Sphere" then
        part = createSphere(obj.Position, color, transparency, material)
    end

    local line
    if showLine and self.Enabled then
        line = createLine(part, Camera, color)
    end

    table.insert(self.Objects, {
        Target = obj,
        Shape = part,
        Line = line,
        Config = {
            Form = form,
            Color = color,
            Transparency = transparency,
            ShowLine = showLine
        }
    })
end

-- Atualização em tempo real
RunService.RenderStepped:Connect(function()
    if not ESP3D.Enabled then
        for _, v in ipairs(ESP3D.Objects) do
            if v.Shape then v.Shape.Transparency = 1 end
            if v.Line then v.Line.Enabled = false end
        end
        return
    end

    for i, data in ipairs(ESP3D.Objects) do
        local obj = data.Target
        local shape = data.Shape

        if obj and obj.Parent and shape then
            shape.Position = obj.Position
            shape.Transparency = data.Config.Transparency
            shape.Color = data.Config.Color
            if data.Line then
                data.Line.Attachment1.WorldPosition = Camera.CFrame.Position
                data.Line.Enabled = true
            end
        else
            if shape then shape:Destroy() end
            if data.Line then data.Line:Destroy() end
            table.remove(ESP3D.Objects, i)
        end
    end
end)

-- Toggle externo
function ESP3D:SetEnabled(state)
    self.Enabled = state
end

return ESP3D
