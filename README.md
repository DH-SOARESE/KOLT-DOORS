
# 🌌 Orion Library – UI Moderna para Scripts Roblox (Mobile-Friendly)

> 📢 **Nota**: Esta biblioteca é uma adaptação da *Orion Library* original, com foco em dispositivos móveis e novos recursos como *Dropdown Toggle*.  
> 👤 **Créditos**: Autor original desconhecido. Caso seja o criador, entre em contato para atribuição de créditos.

---

## 🚀 Visão Geral

A **Orion Library** é uma biblioteca de interface gráfica para scripts Roblox, compatível com executores como **Delta**, **Hydrogen**, entre outros.  
Esta versão é otimizada para dispositivos móveis, mantendo todos os recursos originais e adicionando novos componentes e melhorias visuais.

---

## ✨ Melhorias Adicionais

- ✅ Suporte total a *touchscreen* (toque).
- 📱 Layout responsivo para telas pequenas.
- ⬇️ Novo componente: **Dropdown Toggle** com múltiplas seleções.
- 🔧 ScrollViews otimizados e mais suaves.
- 🧪 Testado com FPS limitado para garantir performance.

---

## 🧰 Recursos Mantidos da Versão Original

- 🎛️ Componentes: Botões, Toggles, Sliders, Labels, Dropdowns, TextBoxes, Binds, Color Pickers.
- 🔔 Notificações com ícones e duração configurável.
- 💾 Salvamento automático de configurações via *Flags*.
- 🎨 Temas customizáveis.
- 🧩 Ícones Feather embutidos.
- 🖱️ Interface arrastável.
- 🧬 Suporte a `gethui()` e `syn.protect_gui()`.

---

## 📦 Como Usar

1. **Carregue a biblioteca:**
   ```lua
   local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/KOLT-DOORS/refs/heads/main/UI%20Library.lua"))()
   ```

2. Inicialize a interface:

OrionLib:Init()


3. Crie uma janela:
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

🧩 Exemplos de Componentes

✅ Toggle com Salvamento
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
⬇️ Dropdown Toggle (Novo)
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

🧹 Remover a Interface
```lua
OrionLib:Destroy()
```


---

📦 Model ESP Library – Destaque Visual para Objetos 3D

> 🎯 Destaque de Models e Partes em jogos como DOORS, com alto desempenho e personalização.




---

🧠 O que é?

Uma biblioteca modular de ESP para Roblox, que permite destacar objetos (Model ou BasePart) no mundo 3D.
Ideal para identificar entidades importantes como portas, armários, chaves e inimigos.


---

✨ Recursos

Recurso	Descrição

✅ Nome Customizado	Exibe texto acima do alvo.
📏 Distância	Mostra distância da câmera.
📍 Tracer	Linha entre a tela e o objeto.
🎨 Highlight Fill	Preenchimento colorido.
🧱 Highlight Outline	Contorno do objeto.
📦 Caixa 3D (Beta)	Renderiza caixa 3D ao redor do objeto.
🧩 Modular	Configurações individuais para cada objeto.



---

🔧 Como Usar

🔹 Carregar a biblioteca:
```lua
local ModelESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/KOLT-DOORS/main/Esp%20library.lua"))()
```
🔸 Adicionar um Model:
```lua
local obj = workspace:WaitForChild("MeuModel")
ModelESP:Add(obj, {
    Name = "Inimigo",
    Color = Color3.fromRGB(255, 0, 0),
    ShowName = true,
    HighlightOutline = true,
    MinDistance = 10,
    MaxDistance = 100,
})
```
🔸 Adicionar uma BasePart:
```lua
local part = workspace:WaitForChild("MinhaParte")
ModelESP:Add(part, {
    Color = Color3.fromRGB(0, 255, 0),
    ShowDistance = true,
    Tracer = true,
    TracerOrigin = "Bottom",
    HighlightFill = true
})
```
🔸 Adicionar Caixa 3D:
```lua
ModelESP:Add(obj, {
    Show3DBox = true,
    BoxColor = Color3.fromRGB(255, 255, 0),
    BoxSize = Vector3.new(4, 5, 4)
})
```

---

⚙️ Parâmetros Disponíveis

Parâmetro	Tipo	Descrição

Target	Instance	Model ou BasePart (obrigatório).
Name	string	Nome a exibir (padrão: Target.Name).
Color	Color3	Cor principal do ESP.
ShowName	boolean	Mostra o nome acima do objeto.
ShowDistance	boolean	Exibe a distância.
Tracer	boolean	Desenha linha na tela.
TracerOrigin	string	Origem da linha: "Top", "Bottom", "Center", etc.
HighlightFill	boolean	Preenchimento com cor.
HighlightOutline	boolean	Contorno visível.
MinDistance	number	Distância mínima para mostrar.
MaxDistance	number	Distância máxima para mostrar.
Show3DBox	boolean	Ativa caixa 3D ao redor do objeto.
BoxColor	Color3	Cor da caixa 3D (padrão: Color).
BoxSize	Vector3	Tamanho da caixa 3D (opcional).



---

🧼 Utilitários

-- Remover alvo específico
ModelESP:Remove(obj)

-- Limpar todos os objetos
```lua
ModelESP:Clear()
```
```lua

-- Desativar temporariamente
ModelESP.Enabled = false
```

---

⚠️ Considerações

Compatível com Model e BasePart.

Para Models, é recomendado definir uma PrimaryPart.

A 3D Box usa Highlight.Adornee para melhor performance.

Ideal para jogos com múltiplos objetos relevantes, como DOORS.



---

🤝 Créditos

🧠 Autor Original: DH SOARES

---

📄 Licença

> Uso pessoal e educacional permitido.
Para redistribuição, forneça os devidos créditos.




---

📬 Contato

Para dúvidas, sugestões ou para reivindicar autoria:

GitHub: github.com/DH-SOARESE/KOLT-DOORS
