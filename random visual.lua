Directory = require(game:GetService("ReplicatedStorage").Library.Directory)
Network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
getgenv().changes = {}

Config = {
    Merchant = false,
    RNGHugeLuck = false,
    RNGBonusLuck = false,
    RNGHatchSpeed = false,
    RNGEggLuck = false,
    Dice2 = false,
    Dice3 = false,
    Dice4 = false
}

function gettable(uu)
    nikita_gay = {}
    for i,v in pairs(require(game:GetService("ReplicatedStorage").Library.Client.Save).Get().Inventory.Pet) do
        if string.find(v.id:lower(), uu:lower()) and not table.find(nikita_gay, v.id) then
            table.insert(nikita_gay, v.id)
        end
    end
    return nikita_gay
end

function gettable2(uu)
    nikita_natural = {}
    for i,v in pairs(Directory.Pets) do
        if string.find(i:lower(), uu:lower()) then
            table.insert(nikita_natural, i)
        end
    end
    return nikita_natural
end

function returnchanges()
    rn_changes = getgenv().changes
    for i,v in pairs(rn_changes) do
        nieger(v[1], v[2])
    end
    changes = {}
end

function deep_copy_table(original)
    local copy = table.clone(original)

    for key, value in pairs(copy) do
        if type(value) == 'table' then
            copy[key] = table.clone(value)
        end
    end

    return copy
end

function nieger(from, to)
    if table.find(getgenv().changes, {from, to}) then
        print("please reset changes to change this pet again")
    end
    table.insert(getgenv().changes, {from, to, deep_copy_table(Directory.Pets[from]), deep_copy_table(Directory.Pets[to])})
    for i,v in pairs(Directory.Pets[from]) do
        Directory.Pets[from][i] = nil
    end
    for i,v in pairs(Directory.Pets[to]) do
        Directory.Pets[from][i] = v
    end
end

function back()
    for i,v in pairs(getgenv().changes) do
        old = v[3]
        new = v[4]
        for i,v in pairs(Directory.Pets[old._id]) do
            Directory.Pets[old._id][i] = nil
        end
        for i,v in pairs(old) do
            Directory.Pets[old._id][i] = v      
        end
    end
    getgenv().changes = {}
end

function Merchant()
    while task.wait() and Config.Merchant do
        for i = 1, 6 do
            wait(0.2)
            game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Merchant_RequestPurchase"):InvokeServer("LuckyDiceMerchant", i)
        end
    end        
end


local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "EGO-HUB", HidePremium = false, SaveConfig = true, ConfigFolder = "X SCRIPTS"})

local Tab = Window:MakeTab({
	Name = "Changer",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

nikita = Tab:AddDropdown({
	Name = "FROM PET",
	Default = "please filter UR pets",
	Options = {"please filter UR pets"},
	Callback = function(Value)
		from = Value
	end    
})

Tab:AddTextbox({
	Name = "Filter Ur Pets",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
        eee = gettable(Value)
        wait(1)
		nikita:Refresh(eee, true)
	end	  
})

mendel = Tab:AddDropdown({
	Name = "TO PET",
	Default = "please filter ALL pets",
	Options = {"please filter ALL pets"},
	Callback = function(Value)
        to = Value
    end    
})

Tab:AddTextbox({
	Name = "Filter All Pets",
	Default = "",
	TextDisappear = true,
	Callback = function(Value)
        uuu = gettable2(Value)
        wait(1)
		mendel:Refresh(uuu, true)
	end	  
})

Tab:AddButton({
	Name = "Change",
	Icon = "rbxassetid://4483345998",
	Callback = function()
		nieger(from, to)
    end
})

local CoolStuff = Window:MakeTab({
	Name = "Cool Stuff",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

CoolStuff:AddButton({
	Name = "Make All Ur Pets Titanics",
	Icon = "rbxassetid://4483345998",
	Callback = function()
        titanics = gettable2("titanic")
		for i,v in pairs(gettable("")) do
            nieger(v, titanics[math.random(1, #titanics)])
        end
    end
})

CoolStuff:AddButton({
	Name = "Return Changes",
	Icon = "rbxassetid://4483345998",
	Callback = function()
        titanics = gettable2("")
		for i,v in pairs(gettable("")) do
            back()
        end
    end
})

local RNG = Window:MakeTab({
	Name = "RNG Autofarm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

RNG:AddToggle(
    {
        Name = "Auto Buy Merchant",
        Default = false,
        Callback = function(m)
            Config.Merchant = m
            spawn(Merchant)
        end
    }
)

function RNGHugeLuck()
    while task.wait and Config.RNGHugeLuck do
        Network:WaitForChild("Rng_PurchaseUpgrade"):InvokeServer("First", "RNGHugeLuck")
    end
end

function RNGBonusLuck()
    while task.wait and Config.RNGBonusLuck do
        Network:WaitForChild("Rng_PurchaseUpgrade"):InvokeServer("First", "RNGBonusLuck")
    end
end

function RNGHatchSpeed()
    while task.wait and Config.RNGHatchSpeed do
        Network:WaitForChild("Rng_PurchaseUpgrade"):InvokeServer("First", "RNGHatchSpeed")
    end
end

function RNGEggLuck()
    while task.wait and Config.RNGEggLuck do
        Network:WaitForChild("Rng_PurchaseUpgrade"):InvokeServer("First", "RNGEggLuck")
    end
end

RNG:AddToggle(
    {
        Name = "Auto Upgrade Egg Luck",
        Default = false,
        Callback = function(m)
            Config.RNGEggLuck = m
            spawn(RNGEggLuck)
        end
    }
)

RNG:AddToggle(
    {
        Name = "Auto Upgrade Hatch Speed",
        Default = false,
        Callback = function(m)
            Config.RNGHatchSpeed = m
            spawn(RNGHatchSpeed)
        end
    }
)

RNG:AddToggle(
    {
        Name = "Auto Upgrade Bonus Luck",
        Default = false,
        Callback = function(m)
            Config.RNGBonusLuck = m
            spawn(RNGBonusLuck)
        end
    }
)

RNG:AddToggle(
    {
        Name = "Auto Upgrade Huge Luck",
        Default = false,
        Callback = function(m)
            Config.RNGHugeLuck = m
            spawn(RNGHugeLuck)
        end
    }
)

function CreateLuckyDice2()
    while task.wait() and Config.Dice2 do
        Network:WaitForChild("LuckyDice_Craft"):InvokeServer("Lucky Dice II", 1)
    end
end    

function CreateLuckyDice3()
    while task.wait() and Config.Dice3 do
        Network:WaitForChild("LuckyDice_Craft"):InvokeServer("Mega Lucky Dice", 1)
    end
end  

function CreateLuckyDice4()
    while task.wait() and Config.Dice4 do
        Network:WaitForChild("LuckyDice_Craft"):InvokeServer("Mega Lucky Dice II", 1)
    end
end    

RNG:AddToggle(
    {
        Name = "Auto Create Lucky Dice II",
        Default = false,
        Callback = function(m)
            Config.Dice2 = m
            spawn(CreateLuckyDice2)
        end
    }
)

RNG:AddToggle(
    {
        Name = "Auto Create Mega Lucky Dice",
        Default = false,
        Callback = function(m)
            Config.Dice3 = m
            spawn(CreateLuckyDice3)
        end
    }
)

RNG:AddToggle(
    {
        Name = "Auto Create Mega Lucky Dice II",
        Default = false,
        Callback = function(m)
            Config.Dice4 = m
            spawn(CreateLuckyDice4)
        end
    }
)
