return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`squig` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("squig", {
			mod_script       = "scripts/mods/squig/squig",
			mod_data         = "scripts/mods/squig/squig_data",
			mod_localization = "scripts/mods/squig/squig_localization",
		})
	end,
	packages = {
		"resource_packages/squig/squig",
	},
}
