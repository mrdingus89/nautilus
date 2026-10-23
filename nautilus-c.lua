-- ===================================================
-- nautilus-m Roblox JSON Polling Execution Client
-- ===================================================
local HttpService = game:GetService("HttpService")

local IP = "192.168.0.109"
local PORT = "3000"
local url = string.format("http://%s:%s", IP, PORT)

local lastExecutionId = 0

print("[Nautilus-M] Sentinel polling client initiated. Target URL: " .. url)

while true do
    print("[Nautilus-M] Pinging server for updates...")
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response and response ~= "" then
        print("[Nautilus-M] Found server JSON waiting. Decoding payload...")
        local decodeSuccess, data = pcall(function()
            return HttpService:JSONDecode(response)
        end)

        if decodeSuccess and data and data.execution_id and data.code then
            print("[Nautilus-M] Server status - Current ID: " .. tostring(data.execution_id) .. " | Last Seen ID: " .. tostring(lastExecutionId))
            if data.execution_id > lastExecutionId then
                lastExecutionId = data.execution_id
                print("[Nautilus-M] New execution detected! ID #" .. tostring(lastExecutionId) .. ". Compiling and executing payload...")
                
                local scriptFunction, loadError = loadstring(data.code)
                if scriptFunction then
                    print("[Nautilus-M] Payload compiled successfully. Running script...")
                    local runSuccess, runError = pcall(scriptFunction)
                    if runSuccess then
                        print("[Nautilus-M] Payload executed cleanly.")
                    else
                        warn("[Nautilus-M] Runtime Error: " .. tostring(runError))
                    end
                else
                    warn("[Nautilus-M] Compilation Error: " .. tostring(loadError))
                end
            else
                print("[Nautilus-M] No new scripts queued. Waiting for updates...")
            end
        else
            warn("[Nautilus-M] Failed to decode JSON from server response or invalid schema.")
        end
    else
        warn("[Nautilus-M] Connection failed or empty response received. Check IP address and server status.")
    end

    task.wait(1.5) -- Poll every 1.5 seconds
end
