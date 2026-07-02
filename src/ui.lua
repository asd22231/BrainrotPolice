--[[
    VEIL UI — Dark Modern Framework
    Colors: Dark Modern Black / Dark Blue / Electric Neon White
    Tween-based animations, draggable, tab system
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Color palette
local Palette = {
    Background    = Color3.fromRGB(12, 12, 16),
    Surface       = Color3.fromRGB(18, 20, 28),
    SurfaceLight  = Color3.fromRGB(24, 28, 38),
    DarkBlue      = Color3.fromRGB(30, 60, 130),
    DarkBlueBright= Color3.fromRGB(45, 85, 175),
    NeonWhite     = Color3.fromRGB(240, 248, 255),
    NeonGlow      = Color3.fromRGB(180, 210, 255),
    Text          = Color3.fromRGB(220, 225, 235),
    TextDim       = Color3.fromRGB(110, 120, 140),
    Stroke        = Color3.fromRGB(35, 40, 55),
    ToggleOff     = Color3.fromRGB(40, 42, 52),
    ToggleOn      = Color3.fromRGB(45, 85, 175),
    Black         = Color3.fromRGB(8, 8, 12),
}

-- Tween configs
local AnimConfig = {
    Fast   = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Medium = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow   = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Parent resolution
local function getGuiParent()
    if CoreGui then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Utility: rounded corner
local function round(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

-- Utility: stroke
local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Palette.Stroke
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

-- Utility: gradient
local function gradient(parent, color1, color2, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(color1, color2)
    g.Rotation = rotation or 0
    g.Parent = parent
    return g
end

-- Utility: padding
local function padding(parent, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, top or 8)
    p.PaddingBottom = UDim.new(0, bottom or 8)
    p.PaddingLeft = UDim.new(0, left or 8)
    p.PaddingRight = UDim.new(0, right or 8)
    p.Parent = parent
    return p
end

-- Utility: flex list
local function listLayout(parent, spacing, direction, padding_val)
    local l = Instance.new("UIListLayout")
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Padding = UDim.new(0, spacing or 6)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    if direction then l.FillDirection = direction end
    if padding_val then l.Padding = UDim.new(0, padding_val) end
    l.Parent = parent
    return l
end

-- Utility: tween
local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- Utility: shadow
local function shadow(parent, radius)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.BackgroundTransparency = 1
    s.Position = UDim2.new(0, -15, 0, -15)
    s.Size = UDim2.new(1, 30, 1, 30)
    s.ZIndex = parent.ZIndex - 1
    s.Image = "rbxassetid://1316045217"
    s.ImageColor3 = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency = 0.6
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(10, 10, 118, 118)
    s.Parent = parent
    return s
end

-- Utility: glow
local function glow(parent, color, size)
    local g = Instance.new("ImageLabel")
    g.Name = "Glow"
    g.BackgroundTransparency = 1
    g.Position = UDim2.new(0, -(size or 20), 0, -(size or 20))
    g.Size = UDim2.new(1, (size or 20) * 2, 1, (size or 20) * 2)
    g.ZIndex = parent.ZIndex - 1
    g.Image = "rbxassetid://5028857084"
    g.ImageColor3 = color or Palette.DarkBlueBright
    g.ImageTransparency = 0.8
    g.ScaleType = Enum.ScaleType.Slice
    g.SliceCenter = Rect.new(24, 24, 48, 48)
    g.Parent = parent
    return g
end

-- ========================================================
-- MAIN GUI OBJECT
-- ========================================================
local VeilUI = {}
VeilUI.__index = VeilUI

function VeilUI.new(config)
    config = config or {}
    local name = config.Name or "Veil UI"
    local size = config.Size or {560, 360}

    -- ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = "VeilUI_" .. tostring(math.random(1000, 9999))
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    sg.Parent = getGuiParent()

    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Palette.Background
    main.BorderSizePixel = 0
    main.ZIndex = 10
    main.ClipsDescendants = false
    main.Parent = sg

    round(main, 10)
    stroke(main, Palette.DarkBlue, 1.5, 0.2)
    shadow(main, 10)
    glow(main, Palette.DarkBlue, 25)

    local glowImg = main:FindFirstChild("Glow")
    glowImg.ImageTransparency = 1

    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 46)
    topBar.BackgroundColor3 = Palette.Surface
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 11
    topBar.Parent = main

    local tbCorner = round(topBar, 10)

    -- Fix bottom corners of topbar to be square
    local tbGradientFix = Instance.new("Frame")
    tbGradientFix.Name = "BottomFix"
    tbGradientFix.Size = UDim2.new(1, 0, 0, 10)
    tbGradientFix.Position = UDim2.new(0, 0, 1, -10)
    tbGradientFix.BackgroundColor3 = Palette.Surface
    tbGradientFix.BorderSizePixel = 0
    tbGradientFix.ZIndex = 10
    tbGradientFix.Parent = topBar

    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 300, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.ZIndex = 12
    title.Parent = topBar

    -- Animated gradient text effect for title
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Palette.DarkBlueBright),
        ColorSequenceKeypoint.new(0.5, Palette.NeonWhite),
        ColorSequenceKeypoint.new(1, Palette.DarkBlueBright),
    })
    titleGradient.Rotation = 0
    titleGradient.Parent = title

    -- Animate the gradient
    task.spawn(function()
        local offset = 0
        while main.Parent do
            offset = offset + 0.01
            if offset > 1 then offset = -1 end
            titleGradient.Offset = Vector2.new(offset, 0)
            task.wait(0.03)
        end
    end)

    -- Split name into colored segments
    -- We'll use RichText
    title.RichText = true
    title.Text = string.format(
        '<font color="rgb(%d,%d,%d)">%s</font> <font color="rgb(%d,%d,%d)">UI</font>',
        Palette.DarkBlueBright.R * 255, Palette.DarkBlueBright.G * 255, Palette.DarkBlueBright.B * 255,
        name,
        Palette.NeonWhite.R * 255, Palette.NeonWhite.G * 255, Palette.NeonWhite.B * 255
    )

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -37, 0.5, -14)
    closeBtn.BackgroundColor3 = Palette.ToggleOff
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.TextColor3 = Palette.TextDim
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 12
    closeBtn.Parent = topBar
    round(closeBtn, 6)

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, AnimConfig.Fast, {BackgroundColor3 = Color3.fromRGB(120, 30, 30), TextColor3 = Palette.NeonWhite})
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, AnimConfig.Fast, {BackgroundColor3 = Palette.ToggleOff, TextColor3 = Palette.TextDim})
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(main, AnimConfig.Medium, {Size = UDim2.new(0, 0, 0, 0)})
        task.wait(0.25)
        sg:Destroy()
    end)

    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "Minimize"
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -72, 0.5, -14)
    minBtn.BackgroundColor3 = Palette.ToggleOff
    minBtn.Text = "—"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 13
    minBtn.TextColor3 = Palette.TextDim
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 12
    minBtn.Parent = topBar
    round(minBtn, 6)

    local minimized = false
    minBtn.MouseEnter:Connect(function()
        tween(minBtn, AnimConfig.Fast, {BackgroundColor3 = Palette.DarkBlue, TextColor3 = Palette.NeonWhite})
    end)
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, AnimConfig.Fast, {BackgroundColor3 = Palette.ToggleOff, TextColor3 = Palette.TextDim})
    end)
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, AnimConfig.Medium, {Size = UDim2.new(0, size[1], 0, 46)})
        else
            tween(main, AnimConfig.Medium, {Size = UDim2.new(0, size[1], 0, size[2])})
        end
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 150, 1, -46)
    sidebar.Position = UDim2.new(0, 0, 0, 46)
    sidebar.BackgroundColor3 = Palette.Surface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 10
    sidebar.Parent = main

    local sidebarLayout = listLayout(sidebar, 4)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    padding(sidebar, 10, 10, 8, 8)

    -- Sidebar stroke
    local sidebarStroke = Instance.new("Frame")
    sidebarStroke.Size = UDim2.new(0, 1, 1, 0)
    sidebarStroke.Position = UDim2.new(1, -1, 0, 0)
    sidebarStroke.BackgroundColor3 = Palette.Stroke
    sidebarStroke.BorderSizePixel = 0
    sidebarStroke.ZIndex = 11
    sidebarStroke.Parent = sidebar

    -- Content area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -150, 1, -46)
    content.Position = UDim2.new(0, 150, 0, 46)
    content.BackgroundTransparency = 1
    content.ZIndex = 10
    content.Parent = main

    -- Tab pages container
    local pages = Instance.new("Frame")
    pages.Name = "Pages"
    pages.Size = UDim2.new(1, -24, 1, -24)
    pages.Position = UDim2.new(0, 12, 0, 12)
    pages.BackgroundTransparency = 1
    pages.Parent = content

    -- Dragging
    local dragging = false
    local dragStart, startPos
    local dragInput

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            tween(main, AnimConfig.Fast, {Position = newPos})
        end
    end)

    -- Object
    local ui = setmetatable({
        ScreenGui = sg,
        Main = main,
        TopBar = topBar,
        Sidebar = sidebar,
        Content = content,
        Pages = pages,
        Tabs = {},
        _tabButtons = {},
        _activeTab = nil,
    }, VeilUI)

    -- Open animation
    task.spawn(function()
        task.wait(0.1)
        tween(main, AnimConfig.Slow, {Size = UDim2.new(0, size[1], 0, size[2])})
        -- Pulse glow
        tween(glowImg, AnimConfig.Slow, {ImageTransparency = 0.5})
        task.wait(0.3)
        tween(glowImg, AnimConfig.Medium, {ImageTransparency = 0.85})
    end)

    return ui
end

-- ========================================================
-- TAB SYSTEM
-- ========================================================
function VeilUI:CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 34)
    tabBtn.BackgroundColor3 = Palette.SurfaceLight
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.BorderSizePixel = 0
    tabBtn.ZIndex = 11
    tabBtn.Parent = self.Sidebar
    round(tabBtn, 6)

    -- Tab label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.Text = name or "Tab"
    label.TextColor3 = Palette.TextDim
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 12
    label.Parent = tabBtn

    -- Indicator bar
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 0, 0, 18)
    indicator.Position = UDim2.new(0, 0, 0.5, -9)
    indicator.BackgroundColor3 = Palette.NeonWhite
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 13
    indicator.Parent = tabBtn
    round(indicator, 3)

    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Name = name and name:gsub("%s", "") or "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Palette.DarkBlue
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 10
    page.Parent = self.Pages

    local pageLayout = listLayout(page, 8)
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    padding(page, 4, 4, 4, 4)

    local tab = {
        Button = tabBtn,
        Label = label,
        Indicator = indicator,
        Page = page,
        Name = name,
    }

    -- Hover
    tabBtn.MouseEnter:Connect(function()
        if self._activeTab ~= tab then
            tween(tabBtn, AnimConfig.Fast, {BackgroundTransparency = 0.4})
            tween(label, AnimConfig.Fast, {TextColor3 = Palette.Text})
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self._activeTab ~= tab then
            tween(tabBtn, AnimConfig.Fast, {BackgroundTransparency = 1})
            tween(label, AnimConfig.Fast, {TextColor3 = Palette.TextDim})
        end
    end)

    -- Click
    local function selectTab()
        if self._activeTab == tab then return end

        -- Deselect previous
        if self._activeTab then
            local old = self._activeTab
            tween(old.Button, AnimConfig.Medium, {BackgroundTransparency = 1})
            tween(old.Label, AnimConfig.Medium, {TextColor3 = Palette.TextDim})
            tween(old.Indicator, AnimConfig.Medium, {Size = UDim2.new(0, 0, 0, 18)})

            -- Fade out old page
            for _, child in ipairs(old.Page:GetChildren()) do
                if child:IsA("GuiObject") then
                    tween(child, AnimConfig.Fast, {Position = UDim2.new(0, 20, child.Position.Y.Scale, child.Position.Y.Offset), BackgroundTransparency = 1})
                end
            end
            task.wait(0.1)
            old.Page.Visible = false
        end

        self._activeTab = tab

        -- Select new
        tween(tabBtn, AnimConfig.Medium, {BackgroundTransparency = 0})
        tween(label, AnimConfig.Medium, {TextColor3 = Palette.NeonWhite})
        tween(indicator, AnimConfig.Medium, {Size = UDim2.new(0, 3, 0, 18)})

        page.Visible = true
        page.Position = UDim2.new(0, 20, 0, 0)

        -- Stagger fade in children
        local children = page:GetChildren()
        for i, child in ipairs(children) do
            if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                child.BackgroundTransparency = 1
                child.Position = UDim2.new(0, 20, child.Position.Y.Scale, child.Position.Y.Offset)
                task.wait(0.03)
                tween(child, AnimConfig.Medium, {Position = UDim2.new(0, 0, child.Position.Y.Scale, child.Position.Y.Offset), BackgroundTransparency = 0})
            end
        end
    end

    tabBtn.MouseButton1Click:Connect(selectTab)

    table.insert(self.Tabs, tab)

    -- Auto-select first tab
    if #self.Tabs == 1 then
        task.wait(0.4)
        selectTab()
    end

    return tab
end

-- ========================================================
-- COMPONENTS
-- ========================================================

-- Toggle
function VeilUI:CreateToggle(tab, text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 38)
    container.BackgroundColor3 = Palette.SurfaceLight
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = tab.Page
    round(container, 6)
    stroke(container, Palette.Stroke, 1, 0.3)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.Text = text or "Toggle"
    label.TextColor3 = Palette.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 11
    label.Parent = container

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -10)
    toggleBg.BackgroundColor3 = Palette.ToggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 11
    toggleBg.Parent = container
    round(toggleBg, 10)

    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 16, 0, 16)
    toggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
    toggleKnob.BackgroundColor3 = Palette.TextDim
    toggleKnob.BorderSizePixel = 0
    toggleKnob.ZIndex = 12
    toggleKnob.Parent = toggleBg
    round(toggleKnob, 8)

    local state = default or false

    local function setState(newState, animate)
        state = newState
        if state then
            if animate then
                tween(toggleBg, AnimConfig.Medium, {BackgroundColor3 = Palette.ToggleOn})
                tween(toggleKnob, AnimConfig.Medium, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Palette.NeonWhite})
            else
                toggleBg.BackgroundColor3 = Palette.ToggleOn
                toggleKnob.Position = UDim2.new(1, -18, 0.5, -8)
                toggleKnob.BackgroundColor3 = Palette.NeonWhite
            end
        else
            if animate then
                tween(toggleBg, AnimConfig.Medium, {BackgroundColor3 = Palette.ToggleOff})
                tween(toggleKnob, AnimConfig.Medium, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Palette.TextDim})
            else
                toggleBg.BackgroundColor3 = Palette.ToggleOff
                toggleKnob.Position = UDim2.new(0, 2, 0.5, -8)
                toggleKnob.BackgroundColor3 = Palette.TextDim
            end
        end
        if callback then callback(state) end
    end

    -- Click area
    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 13
    clickArea.Parent = container

    clickArea.MouseEnter:Connect(function()
        tween(container, AnimConfig.Fast, {BackgroundColor3 = Palette.Surface})
    end)
    clickArea.MouseLeave:Connect(function()
        tween(container, AnimConfig.Fast, {BackgroundColor3 = Palette.SurfaceLight})
    end)

    clickArea.MouseButton1Click:Connect(function()
        setState(not state, true)
    end)

    -- Init
    if state then setState(true, false) end

    return {
        Set = setState,
        Get = function() return state end,
        Frame = container,
    }
end

-- Button
function VeilUI:CreateButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = Palette.SurfaceLight
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.Parent = tab.Page
    round(btn, 6)
    stroke(btn, Palette.Stroke, 1, 0.3)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.Text = text or "Button"
    label.TextColor3 = Palette.Text
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 11
    label.Parent = btn

    btn.MouseEnter:Connect(function()
        tween(btn, AnimConfig.Fast, {BackgroundColor3 = Palette.DarkBlue})
        tween(label, AnimConfig.Fast, {TextColor3 = Palette.NeonWhite})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, AnimConfig.Fast, {BackgroundColor3 = Palette.SurfaceLight})
        tween(label, AnimConfig.Fast, {TextColor3 = Palette.Text})
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, AnimConfig.Fast, {Size = UDim2.new(1, -12, 0, 34), Position = UDim2.new(0, 2, 0, 1)})
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, AnimConfig.Fast, {Size = UDim2.new(1, -8, 0, 36), Position = UDim2.new(0, 0, 0, 0)})
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return btn
end

-- Slider
function VeilUI:CreateSlider(tab, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 48)
    container.BackgroundColor3 = Palette.SurfaceLight
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = tab.Page
    round(container, 6)
    stroke(container, Palette.Stroke, 1, 0.3)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Text = text or "Slider"
    label.TextColor3 = Palette.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 11
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -70, 0, 4)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.Text = tostring(default or min or 0)
    valueLabel.TextColor3 = Palette.NeonWhite
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 11
    valueLabel.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 0, 34)
    track.BackgroundColor3 = Palette.ToggleOff
    track.BorderSizePixel = 0
    track.ZIndex = 11
    track.Parent = container
    round(track, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Palette.DarkBlueBright
    fill.BorderSizePixel = 0
    fill.ZIndex = 12
    fill.Parent = track
    round(fill, 2)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 0, 0.5, -6)
    knob.BackgroundColor3 = Palette.NeonWhite
    knob.BorderSizePixel = 0
    knob.ZIndex = 13
    knob.Parent = track
    round(knob, 6)

    local minValue = min or 0
    local maxValue = max or 100
    local value = default or minValue

    local function update(val)
        value = math.clamp(val, minValue, maxValue)
        local pct = (value - minValue) / (maxValue - minValue)
        tween(fill, AnimConfig.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
        tween(knob, AnimConfig.Fast, {Position = UDim2.new(pct, -6, 0.5, -6)})
        valueLabel.Text = tostring(math.floor(value * 100) / 100)
        if callback then callback(value) end
    end

    local dragging = false
    local inputBtn = Instance.new("TextButton")
    inputBtn.Size = UDim2.new(1, 0, 1, 0)
    inputBtn.BackgroundTransparency = 1
    inputBtn.Text = ""
    inputBtn.ZIndex = 14
    inputBtn.Parent = track

    inputBtn.MouseButton1Down:Connect(function()
        dragging = true
        knob.Size = UDim2.new(0, 16, 0, 16)
        tween(knob, AnimConfig.Fast, {Size = UDim2.new(0, 16, 0, 16), BackgroundColor3 = Palette.NeonGlow})
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false
                tween(knob, AnimConfig.Fast, {Size = UDim2.new(0, 12, 0, 12), BackgroundColor3 = Palette.NeonWhite})
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = input.Position.X - track.AbsolutePosition.X
            local pct = math.clamp(relX / track.AbsoluteSize.X, 0, 1)
            update(minValue + (maxValue - minValue) * pct)
        end
    end)

    update(value)

    return {
        Set = update,
        Get = function() return value end,
        Frame = container,
    }
end

-- Dropdown
function VeilUI:CreateDropdown(tab, text, options, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 36)
    container.BackgroundColor3 = Palette.SurfaceLight
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.ClipsDescendants = true
    container.Parent = tab.Page
    round(container, 6)
    stroke(container, Palette.Stroke, 1, 0.3)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Text = (text or "Dropdown") .. ": " .. (default or options and options[1] or "")
    label.TextColor3 = Palette.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 11
    label.Parent = container

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -28, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.Text = "▼"
    arrow.TextColor3 = Palette.TextDim
    arrow.ZIndex = 11
    arrow.Parent = container

    local optionList = Instance.new("Frame")
    optionList.Size = UDim2.new(1, 0, 0, 0)
    optionList.Position = UDim2.new(0, 0, 0, 36)
    optionList.BackgroundTransparency = 1
    optionList.ZIndex = 12
    optionList.Parent = container

    local optionLayout = listLayout(optionList, 2)

    local expanded = false
    local selected = default or (options and options[1])

    local function toggleExpanded()
        expanded = not expanded
        if expanded then
            local height = 36 + (#options * 28) + 6
            tween(container, AnimConfig.Medium, {Size = UDim2.new(1, -8, 0, height)})
            tween(arrow, AnimConfig.Medium, {Rotation = 180, TextColor3 = Palette.NeonWhite})
        else
            tween(container, AnimConfig.Medium, {Size = UDim2.new(1, -8, 0, 36)})
            tween(arrow, AnimConfig.Medium, {Rotation = 0, TextColor3 = Palette.TextDim})
        end
    end

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 0, 36)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 13
    clickBtn.Parent = container

    clickBtn.MouseEnter:Connect(function()
        tween(container, AnimConfig.Fast, {BackgroundColor3 = Palette.Surface})
    end)
    clickBtn.MouseLeave:Connect(function()
        tween(container, AnimConfig.Fast, {BackgroundColor3 = Palette.SurfaceLight})
    end)
    clickBtn.MouseButton1Click:Connect(toggleExpanded)

    -- Build options
    for _, opt in ipairs(options or {}) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -8, 0, 26)
        optBtn.BackgroundColor3 = Palette.Black
        optBtn.BackgroundTransparency = 0.3
        optBtn.Text = ""
        optBtn.BorderSizePixel = 0
        optBtn.ZIndex = 12
        optBtn.Parent = optionList
        round(optBtn, 4)

        local optLabel = Instance.new("TextLabel")
        optLabel.Size = UDim2.new(1, -16, 1, 0)
        optLabel.Position = UDim2.new(0, 8, 0, 0)
        optLabel.BackgroundTransparency = 1
        optLabel.Font = Enum.Font.Gotham
        optLabel.TextSize = 12
        optLabel.Text = opt
        optLabel.TextColor3 = Palette.TextDim
        optLabel.TextXAlignment = Enum.TextXAlignment.Left
        optLabel.ZIndex = 13
        optLabel.Parent = optBtn

        optBtn.MouseEnter:Connect(function()
            tween(optLabel, AnimConfig.Fast, {TextColor3 = Palette.NeonWhite})
            tween(optBtn, AnimConfig.Fast, {BackgroundTransparency = 0})
        end)
        optBtn.MouseLeave:Connect(function()
            tween(optLabel, AnimConfig.Fast, {TextColor3 = Palette.TextDim})
            tween(optBtn, AnimConfig.Fast, {BackgroundTransparency = 0.3})
        end)
        optBtn.MouseButton1Click:Connect(function()
            selected = opt
            label.Text = (text or "Dropdown") .. ": " .. opt
            tween(optLabel, AnimConfig.Fast, {TextColor3 = Palette.NeonWhite})
            task.wait(0.1)
            tween(optLabel, AnimConfig.Fast, {TextColor3 = Palette.TextDim})
            toggleExpanded()
            if callback then callback(opt) end
        end)
    end

    return {
        Get = function() return selected end,
        Frame = container,
    }
end

-- Textbox
function VeilUI:CreateTextBox(tab, text, placeholder, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 38)
    container.BackgroundColor3 = Palette.SurfaceLight
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = tab.Page
    round(container, 6)
    stroke(container, Palette.Stroke, 1, 0.3)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.Text = text or "Input:"
    label.TextColor3 = Palette.TextDim
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 11
    label.Parent = container

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -120, 1, -8)
    box.Position = UDim2.new(0, 110, 0, 4)
    box.BackgroundTransparency = 1
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Text = ""
    box.PlaceholderText = placeholder or "Enter value..."
    box.PlaceholderColor3 = Palette.TextDim
    box.TextColor3 = Palette.NeonWhite
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ZIndex = 11
    box.ClearTextOnFocus = false
    box.Parent = container

    box.Focused:Connect(function()
        tween(container, AnimConfig.Fast, {BackgroundColor3 = Palette.Surface})
        local s = stroke(container, Palette.DarkBlueBright, 1.5, 0)
        box.FocusLost:Connect(function()
            tween(container, AnimConfig.Fast, {BackgroundColor3 = Palette.SurfaceLight})
            s:Destroy()
            if callback then callback(box.Text) end
        end)
    end)

    return {
        Get = function() return box.Text end,
        Set = function(val) box.Text = val end,
        Frame = container,
    }
end

-- Label
function VeilUI:CreateLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 24)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.Text = text or ""
    label.TextColor3 = Palette.NeonGlow
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 10
    label.Parent = tab.Page
    return label
end

-- ========================================================
-- INITIALIZATION EXAMPLE
-- ========================================================

-- Create the UI
local ui = VeilUI.new({
    Name = "VEIL",
    Size = {580, 380},
})

-- Tab 1: Combat
local combatTab = ui:CreateTab("Combat")

VeilUI:CreateToggle(combatTab, "Aimbot Enabled", false, function(state)
    print("[VEIL] Aimbot: " .. tostring(state))
end)

VeilUI:CreateToggle(combatTab, "Silent Aim", false, function(state)
    print("[VEIL] Silent Aim: " .. tostring(state))
end)

VeilUI:CreateSlider(combatTab, "FOV", 10, 500, 120, function(val)
    print("[VEIL] FOV: " .. tostring(val))
end)

VeilUI:CreateSlider(combatTab, "Smoothness", 0, 1, 0.3, function(val)
    print("[VEIL] Smoothness: " .. tostring(val))
end)

VeilUI:CreateDropdown(combatTab, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, "Head", function(opt)
    print("[VEIL] Target: " .. opt)
end)

-- Tab 2: Visuals
local visualTab = ui:CreateTab("Visuals")

VeilUI:CreateToggle(visualTab, "ESP Boxes", false, function(state)
    print("[VEIL] ESP Boxes: " .. tostring(state))
end)

VeilUI:CreateToggle(visualTab, "Player Names", false, function(state)
    print("[VEIL] Names: " .. tostring(state))
end)

VeilUI:CreateToggle(visualTab, "Tracers", false, function(state)
    print("[VEIL] Tracers: " .. tostring(state))
end)

VeilUI:CreateSlider(visualTab, "ESP Transparency", 0, 1, 0.5, function(val)
    print("[VEIL] ESP Transparency: " .. tostring(val))
end)

VeilUI:CreateDropdown(visualTab, "Tracer Origin", {"Bottom", "Center", "Mouse"}, "Bottom", function(opt)
    print("[VEIL] Tracer Origin: " .. opt)
end)

-- Tab 3: Player
local playerTab = ui:CreateTab("Player")

VeilUI:CreateSlider(playerTab, "Walk Speed", 16, 200, 16, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

VeilUI:CreateSlider(playerTab, "Jump Power", 50, 500, 50, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

VeilUI:CreateToggle(playerTab, "Infinite Jump", false, function(state)
    if state then
        _G.VeilInfJump = true
        LocalPlayer.Character.Humanoid.Jumping:Connect(function()
            if _G.VeilInfJump then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        _G.VeilInfJump = false
    end
end)

VeilUI:CreateButton(playerTab, "Reset Character", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)

-- Tab 4: Misc
local miscTab = ui:CreateTab("Misc")

VeilUI:CreateTextBox(miscTab, "Command", "Enter command...", function(text)
    print("[VEIL] Command: " .. text)
end)

VeilUI:CreateButton(miscTab, "Copy Discord", function()
    if setclipboard then
        setclipboard("discord.gg/yourserver")
    end
end)

VeilUI:CreateButton(miscTab, "Unload UI", function()
    ui.ScreenGui:Destroy()
end)

VeilUI:CreateLabel(miscTab, "VEIL UI v1.0 — Built by Zed")
VeilUI:CreateLabel(miscTab, "VEIL Scripting v1.0 — Built by Zed and Kivix")