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


local function replace_textures(unit)
    if Unit.has_data(unit, "mat_to_use") then
        local mat = Unit.get_data(unit, "mat_to_use")
        local mat_slot = Unit.get_data(unit, "mat_slot")
        local color = Unit.get_data(unit, "color")
        local color_slot = Unit.get_data(unit, "color_slot")
        local normal = Unit.get_data(unit, "normal")
        local norm_slot = Unit.get_data(unit, "norm_slot")
        local gloss = Unit.get_data(unit, "gloss")
        local gloss_slot = Unit.get_data(unit, "gloss_slot")
        print(mat)
        print(color)
        print(color_slot)
        print(unit)
        Unit.set_material(unit, mat_slot, mat)
        local num_meshes = Unit.num_meshes(unit)
        for i = 0, num_meshes - 1, 1 do
            local mesh = Unit.mesh(unit, i)
            local num_mats = Mesh.num_materials(mesh)
            for j = 0, num_mats - 1, 1 do
                local mat = Mesh.material(mesh, j)
                Material.set_texture(mat, color_slot, color)
                Material.set_texture(mat, norm_slot, normal)
                Material.set_texture(mat, gloss_slot, gloss)               
            end
        end
    end 
end

mod:command("spawn_squig", "", function()
    local unit = spawn_package_to_player("units/squig_herd/grn_squig_herd_01")
    replace_textures(unit)
end)

mod:hook(UnitSpawner, 'create_unit_extensions', function (func, self, world, unit, unit_template_name, extension_init_data)
    replace_textures(unit)
    return func(self, world, unit, unit_template_name, extension_init_data)
end)