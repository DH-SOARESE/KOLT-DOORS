--[[
📦 Model ESP Library - Versão Completa, Elegante e RGB
👤 Autor: DH SOARES (Melhorado por ChatGPT)

🎯 Recursos:
✅ Nome + Distância + Tracer com efeito suave
✅ Highlight (contorno + preenchimento)
✅ Caixa 3D com cor RGB animada opcional
✅ Distância mínima/máxima
✅ Suporte a Model ou BasePart
✅ Configuração individual para cada alvo
✅ Opção RGB dinâmica (ciclo de cores) ativável via config.UseRGB
]]

local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local ModelESP = {}
ModelESP.Objects = {}

local tracerOrigins = {
    Top = function(vs) return Vector2.new(vs.X / 2, 0) end,
    Center = function(vs) return Vector2.new(vs.X / 2, vs.Y / 2) end,
    Bottom = function(vs) return Vector2.new(vs.X / 2, vs.Y) end,
}

local function getModelCenter(model)
    local total, count = Vector3.new(0,0,0), 0
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            total += part.Position
            count += 1
        end
    end
    if count == 0 then return nil end
    return total / count
end

local function createDrawing(class, props)
    local obj = Drawing.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function createBoxAdornment(part, color)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBoxAdornment"
    box.Adornee = part
    box.Size = part.Size
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Color3 = color
    box.Transparency = 0.4 -- mais suave
    box.Parent = part
    return box
end

local function HSVToRGB(h, s, v)
    local r, g, b

    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return Color3.new(r, g, b)
end

function ModelESP:Add(target, config)
    if not target or not target:IsA("Instance") then return end

    local base = target:IsA("Model") and (target.PrimaryPart or target:FindFirstChildWhichIsA("BasePart"))  
        or (target:IsA("BasePart") and target)  

    if not base then return end  

    -- Remove highlights/box antigos
    for _, obj in pairs(target:GetChildren()) do  
        if obj:IsA("Highlight") and obj.Name:match("^ESPHighlight") then obj:Destroy() end  
        if obj:IsA("BoxHandleAdornment") and obj.Name == "ESPBoxAdornment" then obj:Destroy() end  
    end  

    local color = config.Color or Color3.new(1, 1, 1)  

    local cfg = {  
        Target = target,  
        BasePart = base,  
        Color = color,  
        Name = config.Name or target.Name,  
        ShowName = config.ShowName or false,  
        ShowDistance = config.ShowDistance or false,  
        Tracer = config.Tracer or false,  
        HighlightFill = config.HighlightFill or false,  
        HighlightOutline = config.HighlightOutline or false,  
        Box3D = config.Box3D or false,  
        TracerOrigin = config.TracerOrigin or "Bottom",  
        MinDistance = config.MinDistance or 0,  
        MaxDistance = config.MaxDistance or math.huge,  
        UseRGB = config.UseRGB or false, -- novo flag RGB
        RGBHue = 0, -- usado para animar cor RGB
    }  

    -- Cria linhas e textos (Drawing) com fontes mais suaves e arredondadas
    cfg.tracerLine = cfg.Tracer and createDrawing("Line", {  
        Thickness = 2,  
        Color = color,  
        Transparency = 1,  
        Visible = false,  
    }) or nil  

    cfg.nameText = cfg.ShowName and createDrawing("Text", {  
        Text = cfg.Name,  
        Color = color,  
        Size = 18,  
        Center = true,  
        Outline = true,  
        Font = 2,  
        Visible = false  
    }) or nil  

    cfg.distanceText = cfg.ShowDistance and createDrawing("Text", {  
        Text = "",  
        Color = color,  
        Size = 14,  
        Center = true,  
        Outline = true,  
        Font = 2,  
        Visible = false  
    }) or nil  

    cfg.highlightFill = cfg.HighlightFill and Instance.new("Highlight") or nil  
    cfg.highlightOutline = cfg.HighlightOutline and Instance.new("Highlight") or nil  
    cfg.boxAdornment = cfg.Box3D and createBoxAdornment(base, color) or nil  

    if cfg.highlightFill then  
        cfg.highlightFill.Name = "ESPHighlightFill"  
        cfg.highlightFill.Adornee = target  
        cfg.highlightFill.FillColor = color  
        cfg.highlightFill.FillTransparency = 0.5  
        cfg.highlightFill.OutlineTransparency = 1  
        cfg.highlightFill.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop  
        cfg.highlightFill.Parent = workspace  
    end  

    if cfg.highlightOutline then  
        cfg.highlightOutline.Name = "ESPHighlightOutline"  
        cfg.highlightOutline.Adornee = target  
        cfg.highlightOutline.FillTransparency = 1  
        cfg.highlightOutline.OutlineColor = color  
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
            if obj.boxAdornment then obj.boxAdornment:Destroy() end
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
        if obj.boxAdornment then obj.boxAdornment:Destroy() end
    end
    ModelESP.Objects = {}
end

RunService.RenderStepped:Connect(function(dt)
    local vs = camera.ViewportSize

    for i = #ModelESP.Objects, 1, -1 do  
        local esp = ModelESP.Objects[i]  
        local target = esp.Target  
        if not target or not target.Parent then  
            ModelESP:Remove(target)  
            continue  
        end  

        local pos3D = target:IsA("Model") and getModelCenter(target) or esp.BasePart.Position  
        if not pos3D then continue end  

        local success, pos2D = pcall(function()  
            return camera:WorldToViewportPoint(pos3D)  
        end)  

        local distance = (camera.CFrame.Position - pos3D).Magnitude  
        local visible = success and pos2D.Z > 0 and distance >= esp.MinDistance and distance <= esp.MaxDistance  

        if not visible then  
            if esp.tracerLine then esp.tracerLine.Visible = false end  
            if esp.nameText then esp.nameText.Visible = false end  
            if esp.distanceText then esp.distanceText.Visible = false end  
            if esp.highlightFill then esp.highlightFill.Enabled = false end  
            if esp.highlightOutline then esp.highlightOutline.Enabled = false end  
            if esp.boxAdornment then esp.boxAdornment.Visible = false end  
            continue  
        end  

        local screenPos = Vector2.new(pos2D.X, pos2D.Y)  

        -- Atualiza cor RGB animada se ativo
        if esp.UseRGB then
            esp.RGBHue = (esp.RGBHue + dt * 0.4) % 1
            esp.Color = HSVToRGB(esp.RGBHue, 1, 1)
        end

        if esp.tracerLine then  
            esp.tracerLine.From = tracerOrigins[esp.TracerOrigin](vs)  
            esp.tracerLine.To = screenPos  
            esp.tracerLine.Color = esp.Color  
            esp.tracerLine.Transparency = 0.8
            esp.tracerLine.Visible = true  
        end  

        if esp.nameText then  
            esp.nameText.Position = screenPos - Vector2.new(0, 22)  
            esp.nameText.Text = esp.Name  
            esp.nameText.Color = esp.Color  
            esp.nameText.Visible = true  
        end  

        if esp.distanceText then  
            esp.distanceText.Position = screenPos + Vector2.new(0, 14)  
            esp.distanceText.Text = string.format("%.1fm", distance / 3.57)  
            esp.distanceText.Color = esp.Color  
            esp.distanceText.Visible = true  
        end  

        if esp.highlightFill then  
            esp.highlightFill.FillColor = esp.Color  
            esp.highlightFill.Enabled = true  
        end  

        if esp.highlightOutline then  
            esp.highlightOutline.OutlineColor = esp.Color  
            esp.highlightOutline.Enabled = true  
        end  

        if esp.boxAdornment then  
            esp.boxAdornment.Visible = true  
            esp.boxAdornment.Color3 = esp.Color  
            esp.boxAdornment.Size = esp.BasePart.Size  
        end  
    end

end)

return ModelESP
