---

🌌 Orion Library – UI Adaptada para Exploits Roblox (Mobile Friendly)

> 📦 Aviso: Esta biblioteca não foi criada por mim. Apenas fiz adaptações para melhorar o suporte em dispositivos móveis e adicionei melhorias, como o Dropdown Toggle.
👤 Créditos ao autor original da Orion Library (identidade desconhecida). Se você for o criador, entre em contato para adicionar seu nome aqui e receber o devido reconhecimento.




---

🚀 Visão Geral

A Orion Library é uma biblioteca de UI para Roblox desenvolvida para ser utilizada com scripts loadstring() em executores como Delta, Hydrogen e similares.
Esta versão foi adaptada com foco em compatibilidade para dispositivos móveis, mantendo todos os recursos da original e adicionando novos componentes interativos.


---

✨ Melhorias Adicionadas

✅ Suporte completo ao toque (touchscreen).

📱 Layout otimizado para telas menores.

⬇️ Dropdown Toggle: seleção múltipla (não presente na versão original).

🔧 Correções visuais em ScrollView, melhor navegação e responsividade.

🧪 Testado em dispositivos com FPS limitado.



---

🧰 Recursos Originais Mantidos

🎛️ Componentes: Botões, Toggles, Sliders, Labels, Dropdowns, TextBoxes, Binds, Color Pickers.

🔔 Sistema de notificações com ícones e tempo configurável.

💾 Salvamento automático de configurações (Flags).

🎨 Suporte a temas personalizados.

🧩 Ícones Feather totalmente integrados.

🖱️ Interface arrastável.

🧬 Suporte a executores modernos (gethui/syn.protect_gui).



---

📦 Como Usar

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/KOLT-DOORS/refs/heads/main/UI%20Library.lua"))()

OrionLib:Init()

local Window = OrionLib:MakeWindow({
    Name = "Meu Script Incrível",
    SaveConfig = true,
    ConfigFolder = "MeuScriptConfigs",
    IntroText = "Bem-vindo!",
    ShowIcon = true,
    Icon = "rbxassetid://SEU_ICON_ID"
})


---

🧩 Exemplos de Componentes

✅ Toggle com Salvamento

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

⬇️ Dropdown Toggle (Novo)

Tab:AddDropdownToggle({
    Name = "Efeitos Visuais",
    Options = {"Bloom", "Blur", "Vignette"},
    Default = {"Bloom"},
    Callback = function(selected)
        if selected.Blur then
            print("Blur ativado")
        end
    end,
    Flag = "VisualEffects",
    Save = true
})


---

🧹 Remover Interface

OrionLib:Destroy()


---

⚙️ Detalhes Técnicos

GUI protegida automaticamente (gethui(), syn.protect_gui()).

Configurações salvas como .txt por GameId.

Feather Icons carregados diretamente do GitHub.

Total compatibilidade com UserInputService (mouse, teclado, toque).



---

🤝 Créditos

🧠 Autor original da Orion Library – Desconhecido (insira link se souber)

🛠️ Adaptação para mobile, Dropdown Toggle e melhorias gerais: DH SOARES



---

📄 Licença

Uso livre para fins educacionais e pessoais.
Dê os devidos créditos ao autor original e às modificações quando reutilizar ou redistribuir.


---
