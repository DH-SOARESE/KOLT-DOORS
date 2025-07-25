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


---

📦 Model ESP Library - Biblioteca Modular para Destaque de Objetos

> 🚀 Destacando Models e Partes no Roblox com facilidade e performance.
👤 Desenvolvedor: DH SOARES




---

🧠 O que é?

A Model ESP Library é uma biblioteca modular em Lua para Roblox, que permite destacar visualmente objetos (Model ou BasePart) no mundo 3D.
Ideal para jogos como DOORS, onde múltiplos objetos importantes precisam ser identificados com clareza.


---

✨ Recursos

Recurso	Descrição

✅ Nome Customizado	Mostra um nome definido por você acima do alvo.
📏 Distância	Exibe a distância (em metros) entre a câmera e o alvo.
📍 Tracer	Desenha uma linha da tela até o alvo (com origem personalizável).
🎨 Highlight Fill	Preenche o alvo com uma cor translúcida.
🧱 Highlight Outline	Adiciona um contorno visível ao redor do alvo.
📦 Caixa 3D (Beta)	Renderiza uma box highlight 3D ao redor de Models/BaseParts.
🧩 Modular	Suporte individual por objeto, com controle total de visualização.



---

🔧 Como Usar

🔹 Carregando a biblioteca via loadstring:

local ModelESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/DH-SOARESE/KOLT-DOORS/main/Esp%20library.lua"))()


---

🔸 Adicionando um Model com nome e contorno:

local obj = workspace:WaitForChild("MeuModel")
ModelESP:Add(obj, {
    Name = "Inimigo",
    Color = Color3.fromRGB(255, 0, 0),
    ShowName = true,
    HighlightOutline = true,
    MinDistance = 10,
    MaxDistance = 100,
})


---

🔸 Adicionando uma BasePart com distância e tracer:

local part = workspace:WaitForChild("MinhaParte")
ModelESP:Add(part, {
    Color = Color3.fromRGB(0, 255, 0),
    ShowDistance = true,
    Tracer = true,
    TracerOrigin = "Bottom",
    HighlightFill = true
})


---

🔸 Adicionando uma Caixa 3D:

ModelESP:Add(obj, {
    Show3DBox = true,
    BoxColor = Color3.fromRGB(255, 255, 0),
    BoxSize = Vector3.new(4, 5, 4)
})


---

⚙️ Parâmetros Disponíveis

Parâmetro	Tipo	Descrição

Target	Instance	Objeto Model ou BasePart a ser rastreado (obrigatório).
Name	string	Nome exibido (padrão: Target.Name).
Color	Color3	Cor geral do ESP.
ShowName	boolean	Mostra o nome acima do alvo.
ShowDistance	boolean	Mostra a distância até o alvo.
Tracer	boolean	Desenha linha da tela até o alvo.
TracerOrigin	string	Origem da linha: "Top", "Center", "Bottom", "Left", "Right".
HighlightFill	boolean	Ativa preenchimento com cor.
HighlightOutline	boolean	Ativa contorno visível.
MinDistance	number	Distância mínima para aparecer.
MaxDistance	number	Distância máxima para aparecer.
Show3DBox	boolean	Mostra uma caixa 3D ao redor.
BoxColor	Color3	Cor da caixa 3D (padrão: Color).
BoxSize	Vector3	Tamanho fixo da 3D Box (calculado automaticamente se omitido).



---

🧼 Utilitários

-- Remover um alvo específico:
ModelESP:Remove(obj)

-- Limpar todos os objetos rastreados:
ModelESP:Clear()

-- Desabilitar temporariamente o ESP:
ModelESP.Enabled = false


---

⚠️ Considerações

Compatível com Model e BasePart.

Para Models, é recomendado definir uma PrimaryPart.

A 3D Box usa Highlight.Adornee, afetando renderização diretamente no mundo 3D.

O ESP é otimizado para muitos objetos simultâneos, ideal para ambientes como DOORS.



---

🤝 Créditos

👤 Autor original: DH SOARES

🔧 Melhorias: Gemini (OpenAI)

📚 Documentação adaptada: [ChatGPT]



---

📄 Licença

> Uso pessoal e educacional permitido.
Para redistribuição, forneça os devidos créditos ao autor original.




---

📬 Contato

💬 Abra uma issue ou entre em contato via GitHub:
🔗 github.com/DH-SOARESE/KOLT-DOORS


---

Se quiser que eu adicione badges, GIFs de exemplo, ou organize esse conteúdo no próprio repositório como README.md, posso ajudar com isso também.

---
