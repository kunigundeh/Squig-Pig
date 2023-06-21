local no_outfit = {
    --unit_extension_template = "ai_outfit_unit",
	unit_name = "units/beings/player/chr_dummy_hat",
	attachment_node_linking = AttachmentNodeLinking.non_visual_attachment
}
local squig_bag = {
    no_outfit,
}

local archer_bag = {
	no_outfit,
}
InventoryConfigurations['squig'] = {
    enemy_hit_sound = "sword",
	anim_state_event = "to_combat",
	items = {
		squig_bag,
	}
}

InventoryConfigurations['archer'] = {
    enemy_hit_sound = "sword",
	anim_state_event = "to_combat",
	items = {
		archer_bag,
	}
}
--mod:echo(InventoryConfigurations['squig'].count)
InventoryConfigurations['squig'].count = #InventoryConfigurations['archer']
InventoryConfigurations['squig'].name = 'squig'

InventoryConfigurations['archer'].count = #InventoryConfigurations['archer']
InventoryConfigurations['archer'].name = 'archer'
-- for config_name, config in pairs(InventoryConfigurations) do
InventoryConfigurations['squig'].items_n = 0 --InventoryConfigurations['squig'].items and #InventoryConfigurations['squig'].items
InventoryConfigurations['archer'].items_n = 0
assert(AIInventoryTemplates['squig'] == nil, "Can't override configuration based templates")
assert(AIInventoryTemplates['archer'] == nil, "Can't override configuration based templates")

AIInventoryTemplates['squig'] = function ()
	return 'squig'
end

AIInventoryTemplates['archer'] = function ()
	return 'archer'
end

local multiple_configurations = InventoryConfigurations['squig'].multiple_configurations
local multiple_configurations = InventoryConfigurations['archer'].multiple_configurations

if multiple_configurations then
	InventoryConfigurations['squig'].config_lookup = {}
	InventoryConfigurations['archer'].config_lookup = {}

	for i = 1, #multiple_configurations, 1 do
		local config_name = multiple_configurations[i]
		InventoryConfigurations['squig'].config_lookup[config_name] = i
		InventoryConfigurations['archer'].config_lookup[config_name] = i
	end
end
-- end

local num_AIinv = #NetworkLookup.ai_inventory
local num_AIinv_a = #NetworkLookup.ai_inventory
NetworkLookup.ai_inventory[num_AIinv] = 'squig'
NetworkLookup.ai_inventory[num_AIinv_a] = 'archer'


NetworkLookup.ai_inventory['squig'] = num_AIinv
NetworkLookup.ai_inventory['archer'] = num_AIinv_a