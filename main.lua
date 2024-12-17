local lp = game:GetService("Players").LocalPlayer

if getgenv().executed then
    warn("Resetting")
    local s = lp.PlayerGui:FindFirstChild("ScreenGui")

    if s then
        s:Destroy()
    end

    if getgenv().connection then
        getgenv().connection:Disconnect()
        getgenv().connection = nil
    end
end

getgenv().executed = true

local writingSpeed = 600
local humanLike = false

local screenGui = Instance.new("ScreenGui", lp.PlayerGui)
local label = Instance.new("TextLabel", screenGui)
local label2 = Instance.new("TextLabel", screenGui)
local stroke = Instance.new("UIStroke", label2)
local button = Instance.new("TextButton", screenGui)
local button2 = Instance.new("TextButton", screenGui)
local button3 = Instance.new("TextButton", screenGui)
local button4 = Instance.new("TextButton", screenGui)
local textbox = Instance.new("TextBox", screenGui)
local stroke2 = Instance.new("UIStroke", button)
local stroke3 = Instance.new("UIStroke", button2)

label.Size = UDim2.new(1, 0, .9, 0)
label.BackgroundTransparency = 1
label.Text = "Waiting for your turn.."
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 12
label.RichText = true

label2.Size = UDim2.new(0.5, 0, .3, 0)
label2.Position = UDim2.new(0.175, 0, .1, 0)
label2.BackgroundTransparency = 1
label2.Text = ""
label2.TextColor3 = Color3.new(1, 1, 1)
label2.TextXAlignment = Enum.TextXAlignment.Center
label2.TextSize = 32

stroke.Color = Color3.new(1, 0, 0)
stroke.Thickness = 2

button.Size = UDim2.new(.075, 0, .075, 0)
button.Position = UDim2.new(0, 0, .925, 0)
button.Text = "Sort: Random"
button.BackgroundTransparency = .3
button.BackgroundColor3 = Color3.new(.8, 0, 0)
button.TextSize = 12
button.TextColor3 = Color3.new(1, 1, 1)

stroke2.Color = Color3.new(1, 1, 1)
stroke2.Thickness = .5

button2.Size = UDim2.new(.075, 0, .075, 0)
button2.Position = UDim2.new(.075, 0, .925, 0)
button2.Text = "AT: Off"
button2.BackgroundTransparency = .3
button2.BackgroundColor3 = Color3.new(.8, 0, 0)
button2.TextSize = 12
button2.TextColor3 = Color3.new(1, 1, 1)

stroke3.Color = Color3.new(1, 1, 1)
stroke3.Thickness = .5

textbox.Size = UDim2.new(.075, 0, (.075/2), 0)
textbox.Position = UDim2.new(.15, 0, .925, 0)
textbox.Text = writingSpeed
textbox.BackgroundColor3 = Color3.new(.2, .2, .2)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.PlaceholderText = "WPM"
textbox.ClearTextOnFocus = false
textbox.BackgroundTransparency = .3

button3.Size = UDim2.new(.075, 0, (.075/2), 0)
button3.Position = UDim2.new(.15, 0, .962, 0)
button3.BackgroundColor3 = Color3.new(.1, .1, .1)
button3.TextColor3 = Color3.new(1, 1, 1)
button3.Text = "Apply Speed"
button3.BackgroundTransparency = .3

button4.Size = UDim2.new(.043, 0, (0.75/2), 0)
button4.Position = UDim2.new(.226, 0, .962, 0)
button4.Text = "Humanlike"
button4.BackgroundTransparency = .3
button4.BackgroundColor3 = Color3.new(.1, .1, .1)
button4.TextSize = 8
button4.TextColor3 = Color3.new(1, 1, 1)

local site = game:HttpGet("https://raw.githubusercontent.com/Artzified/WordBombDictionary/refs/heads/main/words.txt", true)
local words = string.split(site, "\n")

local blacklist = {}
local currentSort = 0
getgenv().connection = nil
local in_progress = false

function findWords(letters)
    local wordlist = {}
    for _, v in next, words do
        if string.find(string.upper(v), string.upper(letters)) then
            table.insert(wordlist, v)
        end
    end

    for i = #wordlist, 2, -1 do
        local j = math.random(1, i)
        wordlist[i], wordlist[j] = wordlist[j], wordlist[i]
    end

    local result = {}
    for i = 1, math.min(750, #wordlist) do
        table.insert(result, wordlist[i])
    end

    return result
end

button.Activated:Connect(function()
    if currentSort == 2 then
        currentSort = 0
    else
        currentSort += 1
    end

    if currentSort == 0 then
        button.BackgroundColor3 = Color3.new(.8, 0, 0)
        button.Text = "Sort: Random"
    
    elseif currentSort == 1 then
        button.BackgroundColor3 = Color3.new(0, .8, 0)
        button.Text = "Sort: Longest"

    elseif currentSort == 2 then
        button.BackgroundColor3 = Color3.new(0, 0, .8)
        button.Text = "Sort: Shortest"
    end

    if not lp.PlayerGui.GameUI.Container.GameSpace.DefaultUI:FindFirstChild("GameContainer") then
        return
    end

    local ifn = lp.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame
    local tx = ifn.TextFrame
    
    handler(ifn, tx)
end)

button2.Activated:Connect(function()
    autotyping = not autotyping

    if autotyping then
        if humanLike then
            button2.BackgroundColor3 = Color3.new(0, 0, .8)
            button2.Text = "AT: Humanlike"
        else
            button2.BackgroundColor3 = Color3.new(0, .8, 0)
            button2.Text = "AT: On"
        end
        
    else
        button2.BackgroundColor3 = Color3.new(.8, 0, 0)
        button2.Text = "AT: Off"
    end
end)

button3.Activated:Connect(function()
    writingSpeed = textbox.Text
end)

button4.Activated:Connect(function()
    humanLike = not humanLike

    if humanLike then
        if autotyping then
            button2.BackgroundColor3 = Color3.new(0, 0, .8)
            button2.Text = "AT: Humanlike"
        end
        
        button4.BackgroundColor3 = Color3.new(0, .8, 0)
    else
        if autotyping then
            button2.BackgroundColor3 = Color3.new(0, .8, 0)
            button2.Text = "AT: On"
        end

        button4.BackgroundColor3 = Color3.new(.1, .1, .1)
    end
end)

function autotype(result)
	local typebox = lp.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer.DesktopContainer.Typebar.Typebox
	local t = ""
    local hd = {}
    local ex = 1

    if not humanLike then
        for _, v in next, result:split("") do
            t ..= v
            typebox.Text = t
            task.wait(1/((writingSpeed*5)/60))
        end
    else
        task.wait(math.random(1, 1.4))
        
        while ex <= 20 do
            table.insert(hd, math.random(1, 4096))
            ex += 1
            task.wait()
        end

        for _, v in next, result:split("") do

            t ..= v
            typebox.Text = t

            task.wait(1/((writingSpeed*2)/math.random(1, 60)) + 1/((hd[math.random(1, 20)])*math.random(1, 3))/math.random(1, 60))
            task.wait(math.random(0.05, 0.1))
        end
    end

    table.insert(blacklist, result)

    game:GetService("VirtualUser"):TypeKey("0x0D")
end

function handler(ifn, tx)
        if ifn:FindFirstChild("Title").Text == "Quick! Type an English word containing:" then
            local sequence = {}

            for _, v in next, tx:GetChildren() do
                if not v:IsA("Frame") then continue end

                if v.Visible then
                    table.insert(sequence, {
                        letter = v.Letter.TextLabel.Text,
                        x = v.Letter.TextLabel.AbsolutePosition.X
                    })
                end
            end

            table.sort(sequence, function(a, b)
                return a.x < b.x
            end)

            local letters = ""

            for _, v in next, sequence do
                letters ..= v.letter
            end

            local result = findWords(letters)

            if currentSort == 0 then
                
            elseif currentSort == 1 then
                table.sort(result, function(a, b)
                    return #b < #a
                end)
            elseif currentSort == 2 then
                table.sort(result, function(a, b)
                    return #a < #b
                end)
            end

            label.Text = table.concat(result, "\n")

            if autotyping then
                if table.find(blacklist, result[1]) then
                    warn("Blacklisted word found: "..result[rnd]..". Skipping...")

                    rnd += 1
                end
                
                label2.Text = result[1]
                autotype(result[1])
            else
                label2.Text = result[1]
            end
        else
            label.Text = "Waiting for your turn.."
            label2.Text = ""
        end
    end

function create_connection(ifn, tx)
    getgenv().connection = ifn:FindFirstChild("Title"):GetPropertyChangedSignal("Text"):Connect(function() handler(ifn, tx) end)
    handler(ifn, tx)

    local c = ifn:GetPropertyChangedSignal("Parent"):Connect(function()
        if not ifn or not ifn.Parent then
            warn("Deleting connection")
            drop_connection()

            if c then
                c:Disconnect()
                c = nil
            end
        end
    end)
end

function drop_connection()
    if getgenv().connection then
        getgenv().connection:Disconnect()
        getgenv().connection = nil
    end

    in_progress = false
end

task.spawn(function()
    while true do
        task.wait(.1)

        if in_progress then
            continue
        end

        label.Text = "Waiting for your turn.."
        label2.Text = ""

        if not lp.PlayerGui.GameUI.Container.GameSpace.DefaultUI:FindFirstChild("GameContainer") then
            continue
        end

        local ifn = lp.PlayerGui.GameUI.Container.GameSpace.DefaultUI.GameContainer.DesktopContainer.InfoFrameContainer.InfoFrame
        local tx = ifn.TextFrame

        create_connection(ifn, tx)
        in_progress = true
    end
end)
