local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local mainwin = Rayfield:CreateWindow({
    name = "Spin Or Die Script | Looping Hub",
    subtitle = "By IceyWWW",
})

local maintab = mainwin:CreateTab({ name = "Main" })
local statstab = mainwin:CreateTab({ name = "Stats" })
local teleportstab = mainwin:CreateTab({ name = "Teleports" })
local creditstab = mainwin:CreateTab({ name = "Credits" })

do

    local function refreshGunList()
        gunList = {}
        local classics = game:GetService("ReplicatedStorage"):FindFirstChild("Classics")
        if not classics then
            warn("classics folder not found.")
            return
        end

        local function scan(folder, path)
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("Folder") then
                    scan(child, path .. "." .. child.Name)
                else
                    table.insert(gunList, {
                        Name = child.Name,
                        Path = path .. "." .. child.Name,
                        Object = child
                    })
                end
            end
        end
        scan(classics, "Classics")
        print("found " .. #gunList .. " gun(s).")
    end

    local function rebuildDropdown()
        dropdown = nil
        local options = {}
        for _, gun in ipairs(gunList) do
            table.insert(options, gun.Name)
        end
        if #options == 0 then
            options = {"no guns found"}
        end

        dropdown = maintab:CreateDropdown({
            name = "Select a Gun",
            options = options,
            currentOption = options[1],
            flag = "GunDropdown",
            callback = function(option)
                for i, gun in ipairs(gunList) do
                    if gun.Name == option then
                        selectedGunIndex = i
                        break
                    end
                end
            end,
        })
    end

    maintab:CreateButton({
        name = "Equip Selected Gun",
        callback = function()
            if #gunList == 0 then
                warn("no guns loaded.")
                return
            end
            local selected = gunList[selectedGunIndex]
            if not selected then
                warn("no gun selected.")
                return
            end
            local shopEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if shopEvent then shopEvent = shopEvent:FindFirstChild("ShopEvent") end
            if not shopEvent or not shopEvent:IsA("RemoteEvent") then
                warn("shop event not found.")
                return
            end
            shopEvent:FireServer("Equip_Gun", selected.Name)
            print("equipped: " .. selected.Name)
        end,
    })

    task.wait(2)
    refreshGunList()
    rebuildDropdown()
end

do
    local winsAmount = 0
    local killsAmount = 0
    local cashAmount = 0

    statstab:CreateInput({
        name = "Wins Amount",
        placeholder = "Enter number...",
        removeTextAfterFocusLost = false,
        flag = "WinsInput",
        callback = function(text)
            local num = tonumber(text)
            if num then winsAmount = num end
        end,
    })

    statstab:CreateButton({
        name = "Add Wins",
        callback = function()
            if winsAmount <= 0 then
                warn("enter a positive number for wins.")
                return
            end
            local leaderstatsEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if leaderstatsEvent then leaderstatsEvent = leaderstatsEvent:FindFirstChild("LeaderstatsEvent") end
            if not leaderstatsEvent or not leaderstatsEvent:IsA("RemoteEvent") then
                warn("leaderstats event not found.")
                return
            end
            leaderstatsEvent:FireServer("Wins", winsAmount)
            print("added " .. winsAmount .. " wins")
        end,
    })

    statstab:CreateInput({
        name = "Kills Amount",
        placeholder = "Enter number...",
        removeTextAfterFocusLost = false,
        flag = "KillsInput",
        callback = function(text)
            local num = tonumber(text)
            if num then killsAmount = num end
        end,
    })

    statstab:CreateButton({
        name = "Add Kills",
        callback = function()
            if killsAmount <= 0 then
                warn("enter a positive number for kills.")
                return
            end
            local leaderstatsEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if leaderstatsEvent then leaderstatsEvent = leaderstatsEvent:FindFirstChild("LeaderstatsEvent") end
            if not leaderstatsEvent or not leaderstatsEvent:IsA("RemoteEvent") then
                warn("leaderstats event not found.")
                return
            end
            leaderstatsEvent:FireServer("Kills", killsAmount)
            print("added " .. killsAmount .. " kills")
        end,
    })

    statstab:CreateInput({
        name = "Cash Amount",
        placeholder = "Enter number...",
        removeTextAfterFocusLost = false,
        flag = "CashInput",
        callback = function(text)
            local num = tonumber(text)
            if num then cashAmount = num end
        end,
    })

    statstab:CreateButton({
        name = "Add Cash",
        callback = function()
            if cashAmount <= 0 then
                warn("enter a positive number for cash.")
                return
            end
            local leaderstatsEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if leaderstatsEvent then leaderstatsEvent = leaderstatsEvent:FindFirstChild("LeaderstatsEvent") end
            if not leaderstatsEvent or not leaderstatsEvent:IsA("RemoteEvent") then
                warn("leaderstats event not found.")
                return
            end
            leaderstatsEvent:FireServer("Cash", cashAmount)
            print("added " .. cashAmount .. " cash")
        end,
    })
end

do
    teleportstab:CreateButton({
        name = "Teleport to Spawn",
        callback = function()
            local player = game.Players.LocalPlayer
            if not player then return end
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(211, 4, -53)
                print("teleported to spawn.")
            end
        end,
    })

    teleportstab:CreateButton({
        name = "Teleport to Map",
        callback = function()
            local player = game.Players.LocalPlayer
            if not player then return end
            local char = player.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(204.711, 6.825, -129.095)
                print("teleported to map.")
            end
        end,
    })
end

creditstab:CreateText({
    name = "Credits",
    text = "Made by IceyWWW\nJoin the Discord: https://discord.gg/B5qyFzPgmT",
})

creditstab:CreateText({
    name = "Support",
    text = "Report bugs or suggest features in the server.",
})

print("ready.")
