local wezterm = require("wezterm")
local config = require("tabline.config")

return function()
	local os_name = os.getenv("OS")
	local handle
	if os_name == "Windows_NT" then
		handle = io.popen(
			'powershell -Command "Get-WmiObject -Query \\"SELECT * FROM Win32_Processor\\" | ForEach-Object -MemberName LoadPercentage"'
		)
	elseif os_name == "Linux" then
		handle = io.popen("awk '/^cpu / {print ($2+$4)*100/($2+$4+$5)}' /proc/stat")
	else
		handle = io.popen("ps -A -o %cpu | awk '{s+=$1} END {print s \"\"}'")
	end

	if not handle then
		return ""
	end

	local result = handle:read("*a")
	handle:close()

	local cpu = result:gsub("^%s*(.-)%s*$", "%1")

	if os_name ~= "Windows_NT" and os_name ~= "Linux" then
		local handle_cores = io.popen("sysctl -n hw.ncpu")
		if handle_cores then
			local num_cores = handle_cores:read("*a")
			handle_cores:close()
			cpu = tonumber(cpu) / tonumber(num_cores)
		end
	end

	cpu = string.format("%.2f%%", cpu)

	if config.opts.options.icons_enabled then
		cpu = wezterm.nerdfonts.oct_cpu .. " " .. cpu
	end

	return cpu
end
