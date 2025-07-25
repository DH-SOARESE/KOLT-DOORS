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

# 📦 Model ESP Library - Versão Modular Aprimorada

---

## 📄 Descrição

A **Model ESP Library** é um sistema avançado de *Environmental Sensing Perception (ESP)*, projetado para destacar objetos do tipo `Model` ou `BasePart` dentro do ambiente de jogo. Esta biblioteca é otimizada para identificar e exibir informações cruciais sobre alvos, tornando-a ideal para jogos que exigem reconhecimento visual de múltiplos objetos simultaneamente, como DOORS.

Desenvolvida com uma arquitetura modular, a biblioteca oferece flexibilidade e desempenho, permitindo uma personalização granular para cada objeto rastreado.

---

## 💡 Recursos Suportados

A biblioteca oferece uma gama completa de recursos para visualização aprimorada:

* **Nome Personalizado**: Exibe um nome definível para cada objeto.
* **Distância até o Alvo**: Mostra a distância em metros entre a câmera e o objeto.
* **Tracer**: Desenha uma linha na tela, conectando uma origem configurável (topo, centro, fundo, esquerda, direita) até o centro do objeto.
* **Highlight Fill (Preenchimento)**: Preenche o objeto com uma cor translúcida.
* **Highlight Outline (Contorno)**: Desenha um contorno ao redor do objeto.
* **3D Box (Caixa 3D)**: Cria uma caixa tridimensional ao redor do objeto. Esta funcionalidade utiliza a propriedade `Highlight.Adornee` para renderizar uma representação 3D no mundo do jogo, e não um Drawing 2D na tela. A caixa é ajustável em tamanho e cor, e pode ser automaticamente dimensionada com base nas dimensões do modelo/parte.

---

## ⚙️ Instalação e Uso

Para utilizar a biblioteca, copie o código-fonte e execute-o em seu ambiente Roblox Studio através de um `loadstring`.

### Exemplo de Uso:

```lua
-- Carrega a biblioteca (via loadstring ou copiando o código diretamente)
-- Assume que o código da Model ESP Library está em uma variável string 'espLibraryCode'
local ModelESP = loadstring(espLibraryCode)()

-- Exemplo 1: Adicionar um Model com nome e contorno
local targetModel = workspace:WaitForChild("SeuModeloAqui") -- Substitua pelo caminho do seu Model
if targetModel then
    ModelESP:Add(targetModel, {
        Name = "Meu Objeto Importante",
        Color = Color3.fromRGB(0, 255, 0), -- Verde
        ShowName = true,
        HighlightOutline = true,
        MinDistance = 10, -- Mínimo de 10 metros para aparecer
        MaxDistance = 100, -- Máximo de 100 metros para aparecer
    })
end

-- Exemplo 2: Adicionar uma BasePart com preenchimento, distância e tracer
local targetPart = workspace:WaitForChild("SuaParteAqui") -- Substitua pelo caminho da sua BasePart
if targetPart then
    ModelESP:Add(targetPart, {
        Color = Color3.fromRGB(255, 0, 0), -- Vermelho
        ShowDistance = true,
        Tracer = true,
        TracerOrigin = "Bottom", -- Linha saindo da parte inferior da tela
        HighlightFill = true,
    })
end

-- Exemplo 3: Adicionar um Model com 3D Box personalizado
local anotherModel = workspace:WaitForChild("OutroModelo")
if anotherModel then
    ModelESP:Add(anotherModel, {
        Color = Color3.fromRGB(0, 0, 255), -- Azul (para nome, distância, etc.)
        ShowName = true,
        Show3DBox = true,
        BoxColor = Color3.fromRGB(255, 255, 0), -- Amarelo para a caixa 3D
        BoxSize = Vector3.new(5, 5, 5), -- Tamanho fixo da caixa 3D (opcional, será calculado se não fornecido)
    })
end

-- Para remover um objeto do rastreamento:
-- ModelESP:Remove(targetModel)

-- Para limpar todos os objetos rastreados:
-- ModelESP:Clear()

-- Para desabilitar temporariamente todo o ESP (sem remover):
-- ModelESP.Enabled = false

🛠️ Configurações Disponíveis (config na função Add)
Ao adicionar um objeto, você pode passar uma tabela de configuração com as seguintes propriedades:
 * Target: (Instance, obrigatório) O Model ou BasePart a ser rastreado.
 * Color: (Color3, padrão: Color3.fromRGB(255, 255, 255)) A cor principal do ESP (nome, distância, tracer, highlights).
 * Name: (string, padrão: Target.Name) O nome a ser exibido para o objeto.
 * ShowName: (boolean, padrão: false) Se o nome do objeto deve ser exibido.
 * ShowDistance: (boolean, padrão: false) Se a distância até o objeto deve ser exibida.
 * Tracer: (boolean, padrão: false) Se uma linha de tracer deve ser desenhada.
 * HighlightFill: (boolean, padrão: false) Se o objeto deve ter um preenchimento Highlight.
 * HighlightOutline: (boolean, padrão: false) Se o objeto deve ter um contorno Highlight.
 * TracerOrigin: (string, padrão: "Bottom") A origem da linha do tracer. Opções: "Top", "Center", "Bottom", "Left", "Right".
 * MinDistance: (number, padrão: 0) A distância mínima para o ESP ser exibido.
 * MaxDistance: (number, padrão: math.huge) A distância máxima para o ESP ser exibido.
 * Show3DBox: (boolean, padrão: false) Se uma caixa 3D deve ser exibida ao redor do objeto.
 * BoxColor: (Color3, padrão: Color da configuração ou Color3.fromRGB(255, 255, 255)) A cor do contorno da caixa 3D.
 * BoxSize: (Vector3, padrão: calculado automaticamente) O tamanho explícito da caixa 3D. Se não fornecido, a biblioteca tentará calcular o extents do modelo/parte.
⚠️ Observações Importantes
 * Compatibilidade: Funciona com objetos Model ou BasePart diretamente referenciados.
 * Otimização: Projetado para lidar com múltiplos objetos simultaneamente, sendo eficaz em cenários como DOORS.
 * 3D Box: Diferente de outros elementos que são Drawings (2D), a 3D Box utiliza a propriedade Highlight.Adornee para criar uma caixa no mundo 3D do jogo. Isso significa que ela se comporta como um objeto real do jogo e é afetada pela perspectiva da câmera.
 * PrimaryPart para Models: Para que os Highlights e a 3D Box funcionem de forma ideal com Models, é recomendável que o Model tenha um PrimaryPart definido. A biblioteca tenta definir um PrimaryPart automaticamente se um BasePart for encontrado.
🤝 Contribuição
 * Autor Base: DH SOARES
 * Aprimoramentos: Gemini
Sinta-se à vontade para propor melhorias ou relatar problemas.

