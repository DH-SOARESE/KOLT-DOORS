# 🌌 Orion Library - Interface de Usuário Robusta para Roblox Exploits

---

## 🚀 Visão Geral

A Orion Library é uma biblioteca de interface de usuário (UI) poderosa e flexível, projetada especificamente para executores de scripts Roblox, como o Delta. Ela permite a criação rápida e eficiente de UIs interativas e personalizáveis dentro de ambientes de execução, utilizando `loadstring` para injeção. Com um foco em design limpo e funcionalidade, a Orion oferece uma vasta gama de elementos UI e recursos de personalização.

## ✨ Recursos Principais

- **Elementos UI Abrangentes**: Inclui botões, toggles, sliders, dropdowns (seleção única e múltipla), campos de texto, e color pickers.
- **Personalização de Temas**: Suporte a temas, com um tema "Default" incluído, permitindo a fácil adaptação da aparência da UI.
- **Sistema de Notificações**: Crie notificações personalizadas com ícones e tempo de exibição para feedback ao usuário.
- **Funcionalidade de Dragging**: A interface pode ser arrastada pela tela para maior comodidade.
- **Persistência de Configurações**: Opção de salvar e carregar configurações (`flags`) automaticamente para manter o estado da UI entre as sessões.
- **Ícones Feather Integrados**: Utiliza ícones Feather para uma experiência visual aprimorada.
- **Layouts Adaptáveis**: Implementa layouts de lista e preenchimento para organização dinâmica dos elementos.
- **Compatibilidade com Executores**: Projetada para ser executada via `loadstring` em executores como o Delta, garantindo ampla compatibilidade.
- **Interface Intuitiva**: Estrutura de código clara para fácil adição e gerenciamento de elementos UI.

---

## 🛠️ Como Usar

A Orion Library é projetada para ser carregada via `loadstring` em seu executor Roblox.

### Inicialização

Para começar a usar a biblioteca, você precisa carregá-la e inicializá-la.

```lua
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/KOLT-DOORS/refs/heads/main/UI%20Library.lua"))()

OrionLib:Init() -- Inicializa a biblioteca (carrega configs, etc.)

Criando uma Janela
A base da sua UI é a janela principal. Você pode configurá-la com um nome, opções de salvamento de configuração, e até uma tela de introdução.
local Window = OrionLib:MakeWindow({
    Name = "Meu Script Incrível",
    ConfigFolder = "MeuScriptConfigs", -- Pasta para salvar as configs (opcional)
    SaveConfig = true, -- Salva as configurações (opcional)
    IntroEnabled = true, -- Ativa a tela de introdução (opcional, padrão: true)
    IntroText = "Bem-vindo ao Meu Script!", -- Texto da introdução (opcional)
    CloseCallback = function()
        print("Janela fechada!")
    end,
    ShowIcon = true, -- Mostra um ícone no canto superior da janela (opcional, padrão: false)
    Icon = "rbxassetid://SEU_ICON_ID_AQUI", -- ID do ícone (opcional)
    IntroIcon = "rbxassetid://SEU_INTRO_ICON_ID_AQUI" -- ID do ícone da introdução (opcional)
})

Adicionando Abas
Organize seus elementos UI em abas.
local Tab = Window:MakeTab({
    Name = "Funcionalidades Principais",
    Icon = "home", -- Nome do ícone Feather ou rbxassetid
    PremiumOnly = false -- Define se a aba é apenas para usuários premium (opcional)
})

local AnotherTab = Window:MakeTab({
    Name = "Configurações",
    Icon = "settings"
})

Adicionando Seções (Opcional)
Dentro de cada aba, você pode adicionar seções para agrupar elementos relacionados.
local Section = Tab:AddSection({
    Name = "Movimento"
})

Adicionando Elementos UI
Cada elemento UI tem configurações específicas e um Callback que é disparado quando o valor do elemento muda ou uma ação é realizada.
Label
Tab:AddLabel("Informações do Jogo")
Section:AddLabel("Opções de Movimento")

Paragraph
Tab:AddParagraph("Descrição do Script", "Este é um script de exemplo para demonstrar a Orion Library.")

Button
Section:AddButton({
    Name = "Teleportar para Spawn",
    Callback = function()
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace.SpawnLocation.CFrame)
        OrionLib:MakeNotification({
            Name = "Teleporte",
            Content = "Você foi teleportado para o spawn!",
            Time = 3
        })
    end,
    Icon = "arrow-right" -- Nome do ícone Feather ou rbxassetid
})

Toggle
local SpeedToggle = Section:AddToggle({
    Name = "Ativar Super Velocidade",
    Default = false,
    Callback = function(state)
        if state then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end,
    Color = Color3.fromRGB(0, 200, 0), -- Cor do toggle quando ativado (opcional)
    Flag = "SuperSpeedEnabled", -- Nome da flag para salvar a configuração (opcional)
    Save = true -- Salva o estado do toggle (opcional, padrão: false)
})

-- Você pode alterar o estado do toggle via script:
-- SpeedToggle:Set(true)

Slider
local JumpPowerSlider = Section:AddSlider({
    Name = "Poder de Pulo",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
    ValueName = "unidades", -- Nome para exibir ao lado do valor (opcional)
    Color = Color3.fromRGB(0, 100, 200), -- Cor do slider (opcional)
    Flag = "JumpPowerValue", -- Nome da flag (opcional)
    Save = true -- Salva o valor do slider (opcional, padrão: false)
})

-- Você pode alterar o valor do slider via script:
-- JumpPowerSlider:Set(75)

Dropdown (Seleção Única)
local MaterialDropdown = Tab:AddDropdown({
    Name = "Material da Parte",
    Options = {"Plastic", "SmoothPlastic", "Wood", "Metal"},
    Default = "Plastic",
    Callback = function(selectedMaterial)
        for _, part in ipairs(game.Workspace:GetChildren()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material[selectedMaterial]
            end
        end
    end,
    Flag = "SelectedMaterial",
    Save = true
})

-- Para atualizar as opções do dropdown:
-- MaterialDropdown:Refresh({"Brick", "Ice"}, true) -- 'true' para apagar as opções existentes

Dropdown Toggle (Seleção Múltipla)
local EffectsDropdown = Tab:AddDropdownToggle({
    Name = "Efeitos Visuais",
    Options = {"Flicker", "Bloom", "Blur", "Vignette"},
    Default = {"Flicker", "Blur"}, -- Valores padrão selecionados
    Callback = function(selectedValues)
        -- 'selectedValues' é uma tabela associativa (ex: {Flicker = true, Bloom = false})
        if selectedValues.Flicker then
            print("Efeito Flicker ativado!")
        else
            print("Efeito Flicker desativado!")
        end
    end,
    Flag = "ActiveEffects",
    Save = true
})

Bind (Atalho de Teclado/Mouse)
local FlyBind = Tab:AddBind({
    Name = "Ativar Voo",
    Default = Enum.KeyCode.F, -- Tecla padrão (pode ser Enum.UserInputType.MouseButton1, etc.)
    Hold = true, -- Ativa/desativa ao segurar (opcional, padrão: false)
    Callback = function(isHolding) -- 'isHolding' é true quando segurado, false ao soltar (apenas se 'Hold' for true)
        if isHolding then
            print("Voo ativado!")
            -- Implementar lógica de voo aqui
        else
            print("Voo desativado!")
        end
    end,
    Flag = "FlyBind",
    Save = true
})

Textbox
Tab:AddTextbox({
    Name = "Nome do Objeto",
    Default = "Objeto",
    TextDisappear = false, -- O texto desaparece após perder o foco (opcional, padrão: false)
    Callback = function(text)
        print("Novo nome do objeto: " .. text)
    end
})

Colorpicker
local SkyColorPicker = Tab:AddColorpicker({
    Name = "Cor do Céu",
    Default = Color3.fromRGB(100, 150, 200),
    Callback = function(color)
        game.Lighting.Ambient = color
    end,
    Flag = "SkyColor",
    Save = true
})

-- Você pode alterar a cor via script:
-- SkyColorPicker:Set(Color3.fromRGB(255, 0, 0))

Notificações
OrionLib:MakeNotification({
    Name = "Atualização Importante",
    Content = "Um novo recurso foi adicionado!",
    Time = 5, -- Tempo em segundos que a notificação fica visível
    Image = "rbxassetid://SEU_ICON_ID_AQUI" -- Ícone da notificação (opcional)
})

🗑️ Destruição da UI
Para remover completamente a UI da tela:
OrionLib:Destroy()

⚠️ Observações Importantes
 * A Orion Library lida com a proteção de GUI (syn.protect_gui ou gethui()) automaticamente.
 * O sistema de salvamento de configurações (SaveCfg) cria uma pasta e um arquivo .txt com o GameId para cada jogo onde o script é executado.
 * Os ícones Feather são carregados de um link raw.githubusercontent.com. Certifique-se de que o executor tem permissão para fazer requisições HTTP.
 * O código usa UserInputService.InputEnded para compatibilidade com cliques de mouse e toques em telas touch.
🤝 Contribuições
Para contribuições, por favor, entre em contato com o autor original da biblioteca.

