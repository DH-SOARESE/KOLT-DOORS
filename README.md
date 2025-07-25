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
