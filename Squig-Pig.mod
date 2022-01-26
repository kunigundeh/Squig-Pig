return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Squig-Pig` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Squig-Pig", {
			mod_script       = "scripts/mods/Squig-Pig/Squig-Pig",
			mod_data         = "scripts/mods/Squig-Pig/Squig-Pig_data",
			mod_localization = "scripts/mods/Squig-Pig/Squig-Pig_localization",
		})
	end,
	packages = {
		"resource_packages/Squig-Pig/Squig-Pig",
	},
}
