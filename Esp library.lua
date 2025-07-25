--[[
📦 Model ESP Library - Versão Modular Aprimorada
👤 Autor: DH SOARES (Base) / Gemini (Aprimoramentos)

🎯 Função:
Sistema de ESP para destacar objetos do tipo Model ou BasePart no jogo, com opções avançadas.

🧩 Recursos Suportados:
✅ Nome personalizado
✅ Distância até o alvo
✅ Tracer (linha do centro da tela até o alvo)
✅ Highlight Fill (preenchimento)
✅ Highlight Outline (contorno)
✅ 3D Box (caixa 3D ao redor do objeto, ajustável em tamanho e cor)

🔍 Observações:
Compatível com objetos diretamente referenciados (Model/BasePart).
Otimizado para uso em jogos como DOORS, com múltiplos objetos simultâneos.
A opção de '3D Box' utiliza a propriedade 'Highlight.Adornee' para criar uma caixa ao redor do objeto,
tornando-a uma representação 3D no mundo do jogo, e não uma Drawing na tela.
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
    if model.PrimaryPart then
        return model.PrimaryPart.Position
    end

    local total, count = Vector3.zero, 0
    local parts = {}
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") and p:IsDescendantOf(workspace) and p.CanCollide and p.Transparency < 1 then
            table.insert(parts, p)
            total += p.Position
            count += 1
        end
    end

    if count == 0 then
        -- Fallback if no suitable parts found, try any BasePart
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                return p.Position -- Return the position of the first BasePart found
            end
        end
        return nil -- No BasePart found
    end

    local center = total / count
    if center.Magnitude ~= center.Magnitude then return nil end -- NaN check
    return center
end

local function getModelExtents(model)
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

    local cframe = model:GetPrimaryPartCFrame() or CFrame.new() -- Use primary part or default
    if not model.PrimaryPart and model:IsA("Model") then
        local parts = {}
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p:IsDescendantOf(workspace) then
                table.insert(parts, p)
            end
        end
        if #parts > 0 then
            -- Create a bounding box around all parts if no PrimaryPart
            local modelBoundingBox = parts[1].CFrame:ToWorldSpace(CFrame.new(parts[1].Size.X/2, parts[1].Size.Y/2, parts[1].Size.Z/2)).Position
            minX, minY, minZ = modelBoundingBox.X, modelBoundingBox.Y, modelBoundingBox.Z
            maxX, maxY, maxZ = modelBoundingBox.X, modelBoundingBox.Y, modelBoundingBox.Z

            for _, part in ipairs(parts) do
                local obb = part:GetBoundingBox() -- Returns (CFrame, Vector3 size)
                local corners = {
                    obb.CFrame * CFrame.new(obb.Size.X/2, obb.Size.Y/2, obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(-obb.Size.X/2, obb.Size.Y/2, obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(obb.Size.X/2, -obb.Size.Y/2, obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(obb.Size.X/2, obb.Size.Y/2, -obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(-obb.Size.X/2, -obb.Size.Y/2, obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(-obb.Size.X/2, obb.Size.Y/2, -obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(obb.Size.X/2, -obb.Size.Y/2, -obb.Size.Z/2).Position,
                    obb.CFrame * CFrame.new(-obb.Size.X/2, -obb.Size.Y/2, -obb.Size.Z/2).Position,
                }
                for _, corner in ipairs(corners) do
                    minX = math.min(minX, corner.X)
                    minY = math.min(minY, corner.Y)
                    minZ = math.min(minZ, corner.Z)
                    maxX = math.max(maxX, corner.X)
                    maxY = math.max(maxY, corner.Y)
                    maxZ = math.max(maxZ, corner.Z)
                end
            end
        else
            return Vector3.new(0,0,0) -- No parts, return zero size
        end
    elseif model:IsA("BasePart") then
        local obb = model:GetBoundingBox()
        local size = obb.Size
        return size
    else
        return Vector3.new(0,0,0) -- For other instance types, return zero size
    end

    local size = Vector3.new(maxX - minX, maxY - minY, maxZ - minZ)
    return size
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
        -- Try to set PrimaryPart if not already set, for better Adornee behavior
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
        Show3DBox = config.Show3DBox or false, -- New option for 3D Box
        BoxColor = config.BoxColor or config.Color or Color3.fromRGB(255, 255, 255), -- New color for 3D Box
        BoxSize = config.BoxSize, -- New size for 3D Box (Vector3)
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
    cfg.highlight3DBox = cfg.Show3DBox and Instance.new("Highlight") or nil -- New Highlight for 3D Box

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

    if cfg.highlight3DBox then
        cfg.highlight3DBox.Name = "ESP3DBoxHighlight"
        cfg.highlight3DBox.Adornee = adornee
        cfg.highlight3DBox.FillTransparency = 1 -- Make fill transparent for box
        cfg.highlight3DBox.OutlineColor = cfg.BoxColor
        cfg.highlight3DBox.OutlineTransparency = 0 -- Make outline visible
        cfg.highlight3DBox.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        cfg.highlight3DBox.Parent = workspace
        -- If BoxSize is not provided, try to calculate based on model/part extents
        if not cfg.BoxSize then
            cfg.BoxSize = getModelExtents(target)
        end
        -- Adjust the highlight's Extents if a custom BoxSize is provided
        if cfg.BoxSize then
            -- Highlight Extents are relative to the adornee's primary part CFrame or the part's CFrame
            -- We need to create a dummy part to set its size and then use its bounding box for highlight.
            -- This is a common workaround as Highlight doesn't have a direct 'Size' property.
            local dummyPart = Instance.new("Part")
            dummyPart.Size = cfg.BoxSize
            dummyPart.Transparency = 1
            dummyPart.CanCollide = false
            dummyPart.Anchored = true
            dummyPart.Parent = workspace
            cfg.highlight3DBox.Adornee = dummyPart
            -- Position the dummy part at the target's center, if it's a model
            if target:IsA("Model") and target.PrimaryPart then
                dummyPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0,0,0) -- Align with the primary part
            elseif target:IsA("BasePart") then
                dummyPart.CFrame = target.CFrame * CFrame.new(0,0,0) -- Align with the part
            end
            cfg._dummyPart = dummyPart -- Store reference to dummy part for cleanup
        end
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
            if obj.highlight3DBox then obj.highlight3DBox:Destroy() end -- Destroy 3D box highlight
            if obj._dummyPart then obj._dummyPart:Destroy() end -- Destroy dummy part
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
        if obj.highlight3DBox then obj.highlight3DBox:Destroy() end -- Destroy 3D box highlight
        if obj._dummyPart then obj._dummyPart:Destroy() end -- Destroy dummy part
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

        -- Additional check for invalid position
        if not visible or pos2D.X ~= pos2D.X or pos2D.Y ~= pos2D.Y then
            if esp.tracerLine then esp.tracerLine.Visible = false end
            if esp.nameText then esp.nameText.Visible = false end
            if esp.distanceText then esp.distanceText.Visible = false end
            if esp.highlightFill then esp.highlightFill.Enabled = false end
            if esp.highlightOutline then esp.highlightOutline.Enabled = false end
            if esp.highlight3DBox then esp.highlight3DBox.Enabled = false end -- Disable 3D box
            if esp._dummyPart then esp._dummyPart.Transparency = 1 end -- Hide dummy part
            continue
        end

        -- Tracer
        if esp.tracerLine then
            esp.tracerLine.From = tracerOrigins[esp.TracerOrigin](vs)
            esp.tracerLine.To = Vector2.new(pos2D.X, pos2D.Y)
            esp.tracerLine.Visible = true
            esp.tracerLine.Color = esp.Color
        end

        -- Name
        if esp.nameText then
            esp.nameText.Position = Vector2.new(pos2D.X, pos2D.Y - 20)
            esp.nameText.Visible = true
            esp.nameText.Text = esp.Name
            esp.nameText.Color = esp.Color
        end

        -- Distance
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

        -- 3D Box
        if esp.highlight3DBox then
            esp.highlight3DBox.Enabled = true
            esp.highlight3DBox.OutlineColor = esp.BoxColor
            if esp._dummyPart then
                -- Position the dummy part accurately
                local targetCFrame = nil
                if target:IsA("Model") and target.PrimaryPart then
                    targetCFrame = target.PrimaryPart.CFrame
                elseif target:IsA("BasePart") then
                    targetCFrame = target.CFrame
                end
                if targetCFrame then
                    esp._dummyPart.CFrame = targetCFrame
                    esp._dummyPart.Transparency = 0.999 -- Make it almost invisible but still affect highlight
                end
            end
        end
    end
end)

return ModelESP
