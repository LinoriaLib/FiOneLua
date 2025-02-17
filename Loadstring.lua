local HttpService = game:GetService("HttpService")

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

