# 🌌 Orion Library – UI para Exploits Roblox (Mobile-Friendly)

> 📢 **Nota**: Esta biblioteca é uma adaptação da Orion Library original, com foco em suporte a dispositivos móveis e novos recursos, como o *Dropdown Toggle*.  
> 👤 **Créditos**: Autor original desconhecido. Se você for o criador, entre em contato para receber o devido reconhecimento!

---

## 🚀 Visão Geral

A **Orion Library** é uma biblioteca de interface de usuário (UI) para scripts Roblox, compatível com executores como **Delta**, **Hydrogen** e outros via `loadstring()`. Esta versão foi otimizada para dispositivos móveis, mantendo todos os recursos originais e introduzindo melhorias exclusivas.

---

## ✨ Melhorias Adicionadas

- ✅ **Suporte total a toque** (*touchscreen*) para dispositivos móveis.
- 📱 **Layout responsivo** otimizado para telas menores.
- ⬇️ **Dropdown Toggle**: Novo componente para seleção múltipla.
- 🔧 **Melhorias visuais** em *ScrollView*, com navegação mais fluida e responsiva.
- 🧪 **Testada em dispositivos com FPS limitado** para garantir performance.

---

## 🧰 Recursos Originais Mantidos

- 🎛️ **Componentes**: Botões, Toggles, Sliders, Labels, Dropdowns, TextBoxes, Binds, Color Pickers.
- 🔔 **Notificações**: Sistema com ícones e tempo configurável.
- 💾 **Salvamento automático**: Configurações salvas via *Flags*.
- 🎨 **Temas personalizados**: Suporte a customização visual.
- 🧩 **Ícones Feather**: Integrados para uma interface moderna.
- 🖱️ **Interface arrastável**: Experiência de usuário fluida.
- 🧬 **Compatibilidade**: Suporte a executores modernos (`gethui`, `syn.protect_gui`).

---

## 📦 Como Usar

1. Carregue a biblioteca via `loadstring`:
   ```lua
   local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/KOLT-DOORS/refs/heads/main/UI%20Library.lua"))()
   ```

2. Inicialize a biblioteca:
   ```lua
   OrionLib:Init()
   ```

3. Crie uma janela personalizada:
   ```lua
   local Window = OrionLib:MakeWindow({
       Name = "Meu Script Incrível",
       SaveConfig = true,
       ConfigFolder = "MeuScriptConfigs",
       IntroText = "Bem-vindo!",
       ShowIcon = true,
       Icon = "rbxassetid://SEU_ICON_ID"
   })
   ```

---

## 🧩 Exemplos de Componentes

### ✅ Toggle com Salvamento
```lua
Tab:AddToggle({
    Name = "Velocidade",
    Default = false,
    Flag = "SpeedFlag",
    Save = true,
    Callback = function(state)
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = state and 40 or 16
    end
})
```

### ⬇️ Dropdown Toggle (Novo)
```lua
Tab:AddDropdownToggle({
    Name = "Efeitos Visuais",
    Options = {"Bloom", "Blur", "Vignette"},
    Default = {"Bloom"},
    Flag = "VisualEffects",
    Save = true,
    Callback = function(selected)
        if selected.Blur then
            print("Blur ativado")
        end
    end
})
```

---

## 🧹 Remover Interface

Para destruir a interface:
```lua
OrionLib:Destroy()
```

---

## ⚙️ Detalhes Técnicos

- **Proteção da GUI**: Suporte automático a `gethui()` e `syn.protect_gui()`.
- **Salvamento de configurações**: Arquivos `.txt` salvos por `GameId`.
- **Ícones Feather**: Carregados diretamente do GitHub.
- **Compatibilidade**: Suporte a `UserInputService` (mouse, teclado, toque).

---

## 🤝 Créditos

- 🧠 **Autor original**: Desconhecido (entre em contato para créditos).
- 🛠️ **Adaptações e melhorias**: [DH SOARES](https://github.com/DH-SOARESE).

---

## 📄 Licença

- **Uso**: Livre para fins educacionais e pessoais.
- **Distribuição**: Dê créditos ao autor original e às modificações ao reutilizar ou redistribuir.

---

## 📬 Contato

Para sugestões, relatórios de bugs ou para o autor original reivindicar créditos, abra uma *issue* no repositório ou entre em contato diretamente.

---

### 🛠️ Mudanças feitas no README:
1. **Estrutura mais clara**: Seções organizadas com títulos consistentes e emojis para destaque visual.
2. **Linguagem concisa**: Textos simplificados, mantendo clareza e profissionalismo.
3. **Melhorias visuais**: Uso de negrito, itálico e listas para facilitar a leitura.
4. **Correções**: Ajustes em gramática, pontuação e links (ex.: link do GitHub para o autor).
5. **Adição de seção de contato**: Para facilitar comunicação com o mantenedor.
6. **Formatação de código**: Blocos de código Lua mais consistentes e legíveis.
7. **Licença clara**: Reforçada a necessidade de dar créditos ao redistribuir.

Se precisar de ajustes adicionais ou quiser incluir mais detalhes (como links específicos ou imagens), é só avisar!


📦 Model ESP Library - Versão Aprimorada
Este é um sistema de ESP (Extra Sensory Perception) modular e aprimorado, projetado para destacar objetos do tipo Model ou BasePart dentro do ambiente de jogo do Roblox. Ele é otimizado para cenários com múltiplos objetos e pode ser executado via loadstring.
🎯 Funcionalidade
O ESP permite a visualização aprimorada de entidades no jogo, fornecendo informações cruciais sobre sua localização e características.
🧩 Recursos Suportados
 * Nome Personalizado: Exibe um nome configurável acima do objeto.
 * Distância até o Alvo: Mostra a distância numérica entre a câmera do jogador e o objeto.
 * Tracer: Desenha uma linha da borda ou centro da tela até o centro do objeto.
 * Highlight Fill (Preenchimento): Adiciona um preenchimento colorido ao objeto usando o objeto Highlight do Roblox.
 * Highlight Outline (Contorno): Adiciona um contorno colorido ao objeto usando o objeto Highlight do Roblox.
 * 3D Box (Caixa 3D Opcional): Desenha uma caixa 3D ao redor do objeto, utilizando o sistema de Highlight do Roblox para uma representação no mundo do jogo, e não uma Drawing na tela. A cor e o tamanho da caixa são configuráveis.
🔍 Observações
 * Compatibilidade: Funciona com Model (preferencialmente com PrimaryPart definido, mas pode inferir o centro) e BasePart.
 * Otimização: Desenvolvido para ser eficiente, mesmo em jogos com muitos objetos a serem monitorados, como "DOORS".
 * Renderização 3D da Caixa: A funcionalidade de "3D Box" utiliza internamente um Highlight do Roblox, que adere ao Adornee (o objeto do jogo), tornando-a uma representação verdadeiramente 3D no mundo, não uma projeção 2D na tela.
🚀 Como Usar
Para utilizar a biblioteca, você deve carregá-la via loadstring e, em seguida, chamar suas funções.
1. Carregando a Biblioteca
local espCode = [[
-- COLOQUE O CONTEÚDO DO CÓDIGO MELHORADO AQUI
-- O código completo da biblioteca ModelESP que você recebeu.
-- Certifique-se de que esteja todo aqui dentro desta string multi-linha.
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
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                return p.Position
            end
        end
        return nil
    end

    local center = total / count
    if center.Magnitude ~= center.Magnitude then return nil end
    return center
end

local function getModelExtents(model)
    local minX, minY, minZ = math.huge, math.huge, math.huge
    local maxX, maxY, maxZ = -math.huge, -math.huge, -math.huge

    local cframe = model:GetPrimaryPartCFrame() or CFrame.new()
    if not model.PrimaryPart and model:IsA("Model") then
        local parts = {}
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p:IsDescendantOf(workspace) then
                table.insert(parts, p)
            end
        end
        if #parts > 0 then
            local modelBoundingBox = parts[1].CFrame:ToWorldSpace(CFrame.new(parts[1].Size.X/2, parts[1].Size.Y/2, parts[1].Size.Z/2)).Position
            minX, minY, minZ = modelBoundingBox.X, modelBoundingBox.Y, modelBoundingBox.Z
            maxX, maxY, maxZ = modelBoundingBox.X, modelBoundingBox.Y, modelBoundingBox.Z

            for _, part in ipairs(parts) do
                local obb = part:GetBoundingBox()
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
            return Vector3.new(0,0,0)
        end
    elseif model:IsA("BasePart") then
        local obb = model:GetBoundingBox()
        local size = obb.Size
        return size
    else
        return Vector3.new(0,0,0)
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
        if not target.PrimaryPart then
            local primary = target:FindFirstChildWhichIsA("BasePart")
            if primary then target.PrimaryPart = primary end
        end
    elseif target:IsA("BasePart") then
        adornee = target
    else
        return
    end

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
        Show3DBox = config.Show3DBox or false,
        BoxColor = config.BoxColor or config.Color or Color3.fromRGB(255, 255, 255),
        BoxSize = config.BoxSize,
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
    cfg.highlight3DBox = cfg.Show3DBox and Instance.new("Highlight") or nil

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
        cfg.highlight3DBox.FillTransparency = 1
        cfg.highlight3DBox.OutlineColor = cfg.BoxColor
        cfg.highlight3DBox.OutlineTransparency = 0
        cfg.highlight3DBox.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        cfg.highlight3DBox.Parent = workspace
        if not cfg.BoxSize then
            cfg.BoxSize = getModelExtents(target)
        end
        if cfg.BoxSize then
            local dummyPart = Instance.new("Part")
            dummyPart.Size = cfg.BoxSize
            dummyPart.Transparency = 1
            dummyPart.CanCollide = false
            dummyPart.Anchored = true
            dummyPart.Parent = workspace
            cfg.highlight3DBox.Adornee = dummyPart
            if target:IsA("Model") and target.PrimaryPart then
                dummyPart.CFrame = target.PrimaryPart.CFrame * CFrame.new(0,0,0)
            elseif target:IsA("BasePart") then
                dummyPart.CFrame = target.CFrame * CFrame.new(0,0,0)
            end
            cfg._dummyPart = dummyPart
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
            if obj.highlight3DBox then obj.highlight3DBox:Destroy() end
            if obj._dummyPart then obj._dummyPart:Destroy() end
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
        if obj.highlight3DBox then obj.highlight3DBox:Destroy() end
        if obj._dummyPart then obj._dummyPart:Destroy() end
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

        if not visible or pos2D.X ~= pos2D.X or pos2D.Y ~= pos2D.Y then
            if esp.tracerLine then esp.tracerLine.Visible = false end
            if esp.nameText then esp.nameText.Visible = false end
            if esp.distanceText then esp.distanceText.Visible = false end
            if esp.highlightFill then esp.highlightFill.Enabled = false end
            if esp.highlightOutline then esp.highlightOutline.Enabled = false end
            if esp.highlight3DBox then esp.highlight3DBox.Enabled = false end
            if esp._dummyPart then esp._dummyPart.Transparency = 1 end
            continue
        end

        if esp.tracerLine then
            esp.tracerLine.From = tracerOrigins[esp.TracerOrigin](vs)
            esp.tracerLine.To = Vector2.new(pos2D.X, pos2D.Y)
            esp.tracerLine.Visible = true
            esp.tracerLine.Color = esp.Color
        end

        if esp.nameText then
            esp.nameText.Position = Vector2.new(pos2D.X, pos2D.Y - 20)
            esp.nameText.Visible = true
            esp.nameText.Text = esp.Name
            esp.nameText.Color = esp.Color
        end

        if esp.distanceText then
            esp.distanceText.Position = Vector2.new(pos2D.X, pos2D.Y + 6)
            esp.distanceText.Visible = true
            esp.distanceText.Text = string.format("%.1fm", distance / 3.57)
            esp.distanceText.Color = esp.Color
        end

        if esp.highlightFill then
            esp.highlightFill.Enabled = true
            esp.highlightFill.FillColor = esp.Color
        end
        if esp.highlightOutline then
            esp.highlightOutline.Enabled = true
            esp.highlightOutline.OutlineColor = esp.Color
        end

        if esp.highlight3DBox then
            esp.highlight3DBox.Enabled = true
            esp.highlight3DBox.OutlineColor = esp.BoxColor
            if esp._dummyPart then
                local targetCFrame = nil
                if target:IsA("Model") and target.PrimaryPart then
                    targetCFrame = target.PrimaryPart.CFrame
                elseif target:IsA("BasePart") then
                    targetCFrame = target.CFrame
                end
                if targetCFrame then
                    esp._dummyPart.CFrame = targetCFrame
                    esp._dummyPart.Transparency = 0.999
                end
            end
        end
    end
end)

return ModelESP
]]

local ModelESP = loadstring(espCode)()

2. Adicionando um Objeto para ESP
Use a função ModelESP:Add() para adicionar um objeto ao sistema de ESP. Ela aceita dois argumentos: o target (o Model ou BasePart a ser rastreado) e uma tabela config com as opções desejadas.
-- Exemplo 1: Adicionar ESP a uma Parte com caixa 3D padrão
local myPart = workspace:WaitForChild("MyAwesomePart") -- Substitua pelo seu objeto
if myPart then
    ModelESP:Add(myPart, {
        Color = Color3.fromRGB(0, 255, 0),       -- Cor geral do ESP (verde)
        ShowName = true,                        -- Exibir o nome
        ShowDistance = true,                    -- Exibir a distância
        Tracer = true,                          -- Exibir o tracer
        HighlightFill = true,                   -- Preenchimento do highlight
        HighlightOutline = true,                -- Contorno do highlight
        Show3DBox = true,                       -- Habilitar a caixa 3D
        -- BoxColor = Color3.fromRGB(255, 0, 0), -- Opcional: Cor personalizada para a caixa 3D (vermelho)
        -- BoxSize = Vector3.new(5, 5, 5),      -- Opcional: Tamanho personalizado da caixa 3D
    })
end

-- Exemplo 2: Adicionar ESP a um Modelo com caixa 3D personalizada
local myModel = workspace:WaitForChild("MyComplexModel") -- Substitua pelo seu modelo
if myModel then
    ModelESP:Add(myModel, {
        Color = Color3.fromRGB(0, 255, 255),       -- Cor geral do ESP (ciano)
        ShowName = true,                           -- Exibir o nome
        ShowDistance = true,                       -- Exibir a distância
        Tracer = false,                            -- Desabilitar o tracer
        HighlightFill = false,                     -- Desabilitar preenchimento
        HighlightOutline = false,                  -- Desabilitar contorno
        Show3DBox = true,                          -- Habilitar a caixa 3D
        BoxColor = Color3.fromRGB(255, 255, 0),    -- Cor da caixa 3D (amarelo)
        BoxSize = Vector3.new(8, 10, 8),           -- Tamanho personalizado da caixa 3D
    })
end

⚙️ Opções de Configuração (config Tabela)
Ao chamar ModelESP:Add(), você pode fornecer as seguintes opções na tabela config:
 * Target: (Obrigatório) A instância do Model ou BasePart que você deseja rastrear.
 * Color: (Color3, padrão: Color3.fromRGB(255, 255, 255)) A cor principal para o nome, distância, tracer e highlights.
 * Name: (string, padrão: target.Name) O nome a ser exibido.
 * ShowName: (boolean, padrão: false) Se true, exibe o nome.
 * ShowDistance: (boolean, padrão: false) Se true, exibe a distância.
 * Tracer: (boolean, padrão: false) Se true, exibe a linha do tracer.
 * HighlightFill: (boolean, padrão: false) Se true, adiciona um highlight com preenchimento.
 * HighlightOutline: (boolean, padrão: false) Se true, adiciona um highlight com contorno.
 * TracerOrigin: (string, padrão: "Bottom") Ponto de origem do tracer na tela. Opções: "Top", "Center", "Bottom", "Left", "Right".
 * MinDistance: (number, padrão: 0) Distância mínima para o ESP ser visível.
 * MaxDistance: (number, padrão: math.huge) Distância máxima para o ESP ser visível.
 * Show3DBox: (boolean, padrão: false) Se true, renderiza uma caixa 3D ao redor do objeto.
 * BoxColor: (Color3, padrão: config.Color ou Color3.fromRGB(255, 255, 255)) A cor do contorno da caixa 3D.
 * BoxSize: (Vector3, opcional) O tamanho Vector3 da caixa 3D. Se não especificado, o sistema tentará calcular automaticamente os limites do target para ajustar o tamanho da caixa.
🗑️ Removendo ESPs
 * ModelESP:Remove(target): Remove o ESP associado a um target específico.
   ModelESP:Remove(myPart) -- Remove o ESP da 'myPart'

 * ModelESP:Clear(): Remove todos os ESPs ativos.
   ModelESP:Clear() -- Limpa todos os ESPs da tela


