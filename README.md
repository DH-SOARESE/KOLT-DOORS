---

# 🌌 Orion Library – UI Adaptada para Exploits Roblox (Mobile Friendly)

> 📦 **Base original da biblioteca não é de minha autoria. Eu apenas adaptei para funcionar melhor em dispositivos móveis e adicionei algumas melhorias, como suporte a `Dropdown Toggle`.**  
> Créditos ao(s) autor(es) original(is) da [Orion Library](https://github.com/jensonhirst/Orion/blob/main/Documentation.md) 🙏

---

## 🚀 Visão Geral

A Orion Library é uma poderosa biblioteca de UI para Roblox, voltada ao uso em scripts `loadstring()` via executores como **Delta**, **Hydrogen**, entre outros. Esta versão adaptada melhora a compatibilidade com **dispositivos móveis**, mantendo todos os recursos originais e adicionando novos elementos, como o `Dropdown Toggle`.

---

## ✨ Melhorias Adicionadas

- ✅ Suporte completo a **toque em telas móveis (touch)**.
- 🔄 **Botões mais responsivos** e layout adaptado para celulares.
- ⬇️ **Dropdown Toggle** (seleção múltipla): opção que não existia na versão original.
- 🔧 Correções em posicionamento e navegação em `ScrollView`.

---

## 🧰 Recursos Originais Mantidos

- 🎛️ UI completa: botões, toggles, sliders, labels, dropdowns, textboxes, binds, color pickers.
- 🔔 Sistema de notificações com ícones e tempo de exibição.
- 💾 Salvamento automático de configurações (`flags`).
- 🎨 Suporte a temas.
- 🧩 Integração com Feather Icons.
- 🖱️ Interface arrastável.
- 🔗 Suporte a executores modernos como Delta.

---

## 🛠️ Como Usar

```lua
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

📦 Exemplos de Uso

🧩 Dropdown Toggle (Novo)

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

✅ Toggle com Salvamento

local SpeedToggle = Tab:AddToggle({
    Name = "Velocidade",
    Default = false,
    Flag = "SpeedFlag",
    Save = true,
    Callback = function(state)
        local humanoid = game.Players.LocalPlayer.Character.Humanoid
        humanoid.WalkSpeed = state and 40 or 16
    end
})


---

🧹 Remover Interface

OrionLib:Destroy()


---

⚠️ Observações Técnicas

A GUI é protegida automaticamente (syn.protect_gui, gethui()).

Configurações são salvas por jogo (GameId) como .txt.

Feather Icons são carregados via https://raw.githubusercontent.com.

Suporte completo a entrada via UserInputService (mouse e toque).



---

🤝 Créditos

🧠 Autor original da Orion Library – [Inserir link se disponível]

🛠️ Adaptação para mobile & melhorias: DH SOARES



---

📄 Licença

Distribuído livremente para fins educacionais e pessoais. Dê os devidos créditos ao autor original e às modificações.

---
