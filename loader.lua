local function main()
local HttpService = game:GetService("HttpService")
    local function getRawGitHubFile()
        local url = "https://raw.githubusercontent.com/oguzxxxxx/Nis0/refs/heads/main/Nis0.lua"
        local token = "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"

        local response = request({
            Url = url,
            Method = "GET",
            Headers = {
                ["Authorization"] = "token " .. token,
                ["User-Agent"] = "Roblox-Request",
                ["Content-Type"] = "application/json"
            }
        })

        if response.StatusCode == 200 then
            return response.Body
        else
            error("Failed to retrieve file: " .. response.Body)
        end
    end
    local scriptContent = getRawGitHubFile()
    local scriptFunction, loadError = loadstring(scriptContent)
    if scriptFunction then
        scriptFunction()
    end
end
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = game:GetService("Players").LocalPlayer
local function getKeysData()
    local url = "https://nis0.site/keys.json"
    local response = request({
        Url = url,
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response.StatusCode == 200 then
        return HttpService:JSONDecode(response.Body)
    else
        error("Failed to retrieve keys data: " .. response.Body)
    end
end
local function verifyKeyAndHWID(player, key)
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local keysData = getKeysData()

    if not keysData.keys[key] then
        player:Kick("Key does not exist.")
        return
    end

    local keyData = keysData.keys[key]

    if keyData.hwid == nil or keyData.hwid == "null" then
        keyData.hwid = hwid

        local jsonData = HttpService:JSONEncode(keysData)

        local response = request({
            Url = "https://nis0.site/keys.json",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })

        if response.StatusCode == 200 then
            print("HWID registered successfully.")
            main()
        else
            print("Failed to register HWID: " .. response.Body)
            player:Kick("Failed to register HWID.")
        end
    else
        if keyData.hwid ~= hwid then
            player:Kick("Invalid HWID.")
        else
            print("Key and HWID verified successfully.")
            main()
        end
    end
end
local userkey = getgenv().userkey
local player = Players.LocalPlayer
verifyKeyAndHWID(player, userkey)
