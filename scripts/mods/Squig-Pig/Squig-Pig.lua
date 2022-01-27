local mod = get_mod("Squig-Pig")

-- Your mod code goes here.
-- https://vmf-docs.verminti.de

Managers.package:load("units/weapons/player/wpn_empire_handgun_02_t2/wpn_empire_handgun_02_t2_3p", "global")

local unit_path = "units/squig_herd/grn_squig_herd_01"
local num_inv = #NetworkLookup.inventory_packages
local num_husk = #NetworkLookup.husks


NetworkLookup.inventory_packages[num_inv] = unit_path
NetworkLookup.inventory_packages[unit_path] = num_inv
NetworkLookup.husks[num_husk] = unit_path
NetworkLookup.husks[unit_path] = num_husk



mod:dofile("scripts/mods/Squig-Pig/breeds/breed_squig")
mod:dofile("scripts/settings/breeds")
mod:dofile("scripts/mods/Squig-Pig/settings/ai_inventory")
-- mod:dofile("scripts/managers/performance/performance_manager")
-- mod:dofile("scripts/managers/conflict_director/conflict_director")


local function create_lookups(lookup, hashtable)
	local i = #lookup

	for key, _ in pairs(hashtable) do
		i = i + 1
		lookup[i] = key
	end

	return lookup
end
NetworkLookup.breeds = create_lookups({}, Breeds)

Breeds.greenskin_squig.name = "critter_rat"

Breeds.critter_rat["base_unit"] = unit_path
Breeds.critter_rat["hit_zones"]  = {
    neck = {
        prio = 1,
        actors = {
            "c_head"
           
        }
    },
    torso = {
        prio = 2,
        actors = {
            "c_head"
        },
        push_actors = {
            "head_0"
        }
    },
    full = {
        prio = 3,
        actors = {}
    }
}

Breeds.critter_pig["base_unit"] = unit_path
Breeds.critter_pig["hit_zones"]  = {
    neck = {
        prio = 1,
        actors = {
            "c_head"
           
        }
    },
    torso = {
        prio = 2,
        actors = {
            "c_head"
        },
        push_actors = {
            "head_0"
        }
    },
    full = {
        prio = 3,
        actors = {}
    }
}

-- Breeds.skaven_slave['default_inventory_template'] = {'squig'}
-- Breeds.skaven_slave['opt_default_inventory_template'] = {'squig'}
-- Breeds.skaven_slave["base_unit"] = unit_path
-- Breeds.skaven_slave["hit_zones"]  = {
--     neck = {
--         prio = 1,
--         actors = {
--             "c_head"
           
--         }
--     },
--     torso = {
--         prio = 2,
--         actors = {
--             "c_head"
--         },
--         push_actors = {
--             "head_0"
--         }
--     },
--     full = {
--         prio = 3,
--         actors = {}
--     }
-- }


local function replace_textures(unit)
    if Unit.has_data(unit, "mat_to_use") then
        local mat = Unit.get_data(unit, "mat_to_use")

        local mat_slots = {}
        local colors = {}
        local normals = {}
        local glosses = {}
        for i=1, 20, 1 do
            if Unit.has_data(unit, "mat_slots", "slot"..tostring(i)) then 
                mat_slots[i] = Unit.get_data(unit, "mat_slots", "slot"..tostring(i))
            end
            if Unit.has_data(unit, "colors", "slot"..tostring(i)) then 
                colors[i] = Unit.get_data(unit, "colors", "slot"..tostring(i))
            end
            if Unit.has_data(unit, "normals", "slot"..tostring(i)) then 
                normals[i] = Unit.get_data(unit, "normals", "slot"..tostring(i))
            end
            if Unit.has_data(unit, "glosses", "slot"..tostring(i)) then 
                glosses[i] = Unit.get_data(unit, "glosses", "slot"..tostring(i))
            end
        end
       
        local color_slot = Unit.get_data(unit, "color_slot")
        local norm_slot = Unit.get_data(unit, "norm_slot")
        local gloss_slot = Unit.get_data(unit, "gloss_slot")
        print(mat)
        print(color)
        print(color_slot)
        print(unit)
        local num_meshes = Unit.num_meshes(unit)
        for index, mat_slot in pairs(mat_slots) do 
            Unit.set_material(unit, mat_slot, mat)
            for i = 0, num_meshes - 1, 1 do
                local mesh = Unit.mesh(unit, i)
                local num_mats = Mesh.num_materials(mesh)
                for j = 0, num_mats - 1, 1 do
                    local mat = Mesh.material(mesh, j)
    
                    
    
                    Material.set_texture(mat, color_slot, colors[index])
                    Material.set_texture(mat, norm_slot, normals[index])
                    Material.set_texture(mat, gloss_slot, glosses[index])               
                end
            end
        end
        
        
    end 
end

local function spawn_package_to_player (package_name)
	local player = Managers.player:local_player()
	local world = Managers.world:world("level_world")
  
	if world and player and player.player_unit then
	  local player_unit = player.player_unit
  
	  local position = Unit.local_position(player_unit, 0) + Vector3(0, 0, 1)
	  local rotation = Unit.local_rotation(player_unit, 0)
	  local unit = World.spawn_unit(world, package_name, position, rotation)
  
	  mod:chat_broadcast(#NetworkLookup.inventory_packages + 1)
	  return unit
	end
  
	return nil
end

mod:command("spawn_squig", "spawns the squig model without being linked to ai\nthis model can cause crashes", function()
    local unit = spawn_package_to_player("units/squig_herd/grn_squig_herd_01")
    replace_textures(unit)
end)

mod:hook(UnitSpawner, 'create_unit_extensions', function (func, self, world, unit, unit_template_name, extension_init_data)
    replace_textures(unit)
    return func(self, world, unit, unit_template_name, extension_init_data)
end)

-- mod:hook(Unit, "animation_event", function( func, self, event) 
--     mod:echo(tostring(self)..tostring(event))
--     return func(self, event)
-- end)

mod:hook(Unit, 'node', function(func, self, node)
    if Unit.has_node(self, node) then
        return func(self, node)
    end
    local new_node = Unit.get_data(self, 'node_replace')
    return func(self, new_node)
end)

--prevents crash from billhook stagger
local unit_node = Unit.node
local unit_world_position = Unit.world_position
ActionSweep.check_precision_target = function (self, owner_unit, owner_player, dedicated_target_range, check_distance, weapon_furthest_point)
	local current_target = self._precision_target_unit

	if not AiUtils.unit_alive(current_target) then
		return nil
	end

	local first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")

	first_person_extension:disable_rig_movement()

	local pos = first_person_extension:current_position()
	local rot = first_person_extension:current_rotation()
	local direction = Quaternion.forward(rot)
	local node = "j_spine"
    --crash is caused by node being hard coded to j_spine
    if not Unit.has_node(current_target, node) then
        node = Unit.get_data(current_target, 'node_replace')
    end

	local target_position = unit_world_position(current_target, unit_node(current_target, node))
	local good_target = false
	local player_to_target_vector = target_position - pos
	local player_to_target_distance = Vector3.length(player_to_target_vector)
	local player_to_target_unit_dir = Vector3.normalize(player_to_target_vector)
	local dot = Vector3.dot(player_to_target_unit_dir, direction)
	local target_health_extension = ScriptUnit.extension(current_target, "health_system")

	if dot < 0.9 or dedicated_target_range < player_to_target_distance then
		good_target = false
	elseif target_health_extension:is_alive() then
		good_target = true
	end

	return (good_target and current_target) or nil
end

--this enables the breed with creature spawner settings
local spawn_mod = get_mod("CreatureSpawner")

local add_spawn_catagory = {
    greenskin_squig = {
        "misc",
    }
}
table.merge(spawn_mod.unit_categories, table)
breed_name = 'greenskin_squig'
table.insert(spawn_mod["all_units"], breed_name)