-- ==========================================
-- nautilus-c
-- ==========================================
local IP = "192.168.0.109" -- local IP or server host goes here
local PORT = "3000"

local url = string.format("http://%s:%s", IP, PORT)

print("[nautilus-c] querying nautilus-m server at " .. url .. "...")

local success, response = pcall(function()
    return game:HttpGet(url)
end)

if success and response and response ~= "" then
    print("[nautilus-c] Payload received! Executing...")
    local scriptFunction, loadError = loadstring(response)
    if scriptFunction then
        local runSuccess, runError = pcall(scriptFunction)
        if not runSuccess then
            warn("[nautilus-c] runtime error: " .. tostring(runError))
        end
    else
        warn("[nautilus-c] compilation error: " .. tostring(loadError))
    end
else
    warn("[nautilus-c] connection failed, make sure the nautilis application is running")
end
