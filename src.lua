--!nolint
--!nocheck
--[[
    AOT Resistance UI
        i think im the first to make a proper
        script for this game
        top 10 exploiter here!!!
    ~ @dexftl https://github.com/dex4tw
]]--

--[ Resistance Objects ]--
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

--[ Resistance Mods ]--
local Brew = {

}
Brew.getMemory = function()
    local s, result = xpcall(function()
        local Memory
        repeat 
            task.wait(.1) 
            pcall(function()
                Memory = require(Character.ODMG.Client.Memory)
            end)
        until Memory
        return Memory
    end, function()  
        return nil
    end)

    return result
end

Brew.getCoreMemory = function()
    local s, result = xpcall(function()
        local Memory
        repeat 
            task.wait(.1) 
            pcall(function()
                Memory = require(Character.ClientRuntime.CoreMemory)
            end)
        until Memory
        return Memory
    end, function()  
        return nil
    end)

    return result
end

Brew.ODMImprovements = {
    name = "ODMImprovements",
    enabled = false, 
    func = function(self, t: boolean, from: boolean)
        local Memory = Brew.getMemory()

        Memory.rappelSpeed = t and .0 or .0047
        Memory.states.maxGas = t and 9e9 or 3500
        Memory.states.maxBladeState = t and 9e9 or 1000
        Memory.states.currentBladeState = t and 9e9 or 1000
        Memory.states.currentGas = t and 9e9 or 3500

        if from then
            self.enabled = t
        end

        -- print(t, "info from odm func", self.enabled, self, "from", from)
    end
}

Brew.infiniteGas = {
    name = "infiniteGas",
    enabled = false,
    func = function(self, t: boolean, from: boolean) 
        local Memory = Brew.getMemory()
        Memory.states.maxGas = t and 9e9 or 3500
        Memory.states.currentGas = t and 9e9 or 3500

        if from then
            self.enabled = t
        end
    end
}

Brew.infiniteBlades = {
    name = "infiniteBlades",
    enabled = false,
    func = function(self, t: boolean, from: boolean) 
        local Memory = Brew.getMemory()
        Memory.states.maxBladeState = t and 9e9 or 1000
        Memory.states.currentBladeState = t and 9e9 or 1000

        if from then
            self.enabled = t
        end
    end
}

Brew.titanNapeToggle = {
    name = "titanNapeToggle",
    enabled = false,
    func = function(self, t: boolean, from: boolean)
        if from then
            self.enabled = t
        end
    end
}

Brew.titanNapeSlider = {
    name = "titanNapeSlider",
    enabled = false,
    lastarg = 3,
    func = function(self, t: int, from: boolean)
        for i, Titan in pairs(workspace.Titans.Alive:GetChildren()) do
            xpcall(function()
                Titan.Hitboxes.Nape.Size = self.enabled and Vector3.new(t, t, t) or Vector3.new(3, 3, 3)
                Titan.Hitboxes.Nape.Transparency = self.enabled and .4 or 1
            end, function()  
                warn("[Brew]: Could not modify nape of", Titan.Name)
            end)
        end
        
        self.lastarg = t
        self.enabled = Brew.titanNapeToggle.enabled
    end
}

Brew.refreshFunctions = function()
    for i, mod in pairs(Brew) do
        if typeof(mod) == "table" then
            if mod.lastarg then
                mod:func(mod.lastarg, false)
            else
                mod:func(mod.enabled, false)
            end
        end
    end
end

--[ Resistance Console ]--
print[[----------------------------------
| __ ) _ __ _____      __
|  _ \| '__/ _ \ \ /\ / /
| |_) | | |  __/\ V  V /
|____/|_|  \___| \_/\_/    @dexftl - bleh
----------------------------------------------]]
for i, mod in pairs(Brew) do
    if typeof(mod) == "table" then
        print("[Brew]: Loaded mod", mod.name, "status?(enabled)", mod.enabled)
    end
end

--[ Resistance UI ]--
local Library = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/Vape.txt")()
local Window = Library:Window("Brew ("..game.PlaceId..")",Color3.fromRGB(0, 0, 0), Enum.KeyCode.Delete)
local windowInstance = game:GetService("CoreGui"):WaitForChild("ui")
windowInstance.Main:WaitForChild("Title").Text = "Brew ("..game.PlaceId..")"
local homeTab = Window:Tab("Home")
local characterTab = Window:Tab("Character")
local titansTab = Window:Tab("Titans")
local appearanceTab = Window:Tab("Appearance")

characterTab:Toggle("ODM Improvements", false, function(t: boolean)
    Brew.ODMImprovements:func(t, true)
end)
characterTab:Label("Improves speed & functionality")

characterTab:Toggle("Infinite Gas", false, function(t: boolean)
    Brew.infiniteGas:func(t, true)
end)

characterTab:Toggle("Infinite Blades", false, function(t: boolean)
    Brew.infiniteBlades:func(t, true)
end)

titansTab:Toggle("Titan Hitbox Extender", false, function(t: boolean)
    Brew.titanNapeToggle:func(t, true)
end)

titansTab:Slider("Titan Hitbox", 0, 30, 7, function(t: int)
    Brew.titanNapeSlider:func(t, true)
end)

appearanceTab:Colorpicker("Accent Color",Color3.fromRGB(0,0,0), function(t)
	Library:ChangePresetColor(Color3.fromRGB(t.R * 255, t.G * 255, t.B * 255))
end)

appearanceTab:Button("Exit", function()
    for i, mod in pairs(Brew) do
        if typeof(mod) == "table" then
            mod.enabled = false
            brewLoop:Disconnect()
            windowInstance:Destroy()
        end
    end
end)

--[ Resistance Checks ]--
Player.CharacterAdded:Connect(function(i) 
    Character = i
    Brew.refreshFunctions()
end)

local accumulated = 0
brewLoop = game:GetService("RunService").Heartbeat:Connect(function(dt)
    accumulated += dt
    if accumulated >= 0.1 then
        accumulated = 0
        Brew.refreshFunctions()
    end
end)

-- memory.rappelSpeed = 0
-- memory.states.maxGas = 9e9
-- memory.states.maxBladeState = 9e9
-- memory.states.currentBladeState = 9e9
-- memory.states.currentGas = 9e9