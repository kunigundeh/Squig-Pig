local squig_data = {
    detection_radius = 10,
	target_selection = "pick_closest_target",
	run_speed = 6,
	exchange_order = 1,
	flingable = false,
	has_inventory = false,
	perception = "perception_regular",
	not_bot_target = true,
	animation_sync_rpc = "rpc_sync_anim_state_1",
	aoe_radius = 0.1,
	poison_resistance = 70,
	debug_spawn_category = "Misc",
	aoe_height = 0.1,
	cannot_far_path = true,
	walk_speed = 4,
	hit_reaction = "ai_default",
	bone_lod_level = 1,
	hit_effect_template = "HitEffectsCritterRat",
	radius = 1,
	unit_template = "ai_unit_critter",
	perception_previous_attacker_stickyness_value = 0,
	race = "critter",
	no_autoaim = true,
	death_reaction = "ai_default",
	armor_category = 1,
	weapon_reach = 2,
	vortexable = false,
	disable_local_hit_reactions = true,
	behavior = "critter_rat",
	base_unit = "units/squig_herd/grn_squig_herd_01",
	threat_value = 0,
	ignore_activate_unit = true,
	size_variation_range = {
		0.9,
		1.1
	},
	animation_merge_options = {
		idle_animation_merge_options = {},
		move_animation_merge_options = {}
	},
	hitzone_multiplier_types = {},
	hit_zones = {
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
    },
	max_health = {
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1
	},
	num_push_anims = {
		push_backward = 4
	},
	debug_color = {
		255,
		40,
		90,
		170
	},
	allowed_layers = {
		planks = 1.5,
		bot_ratling_gun_fire = 5,
		doors = 1.5,
		destructible_wall = 0,
		bot_poison_wind = 5,
		temporary_wall = 0,
		fire_grenade = 5
	}
}

Breeds.greenskin_squig = table.create_copy(Breeds.greenskin_squig, squig_data)

BreedActions.greenskin_squig = {
	alerted = {
		cooldown = -1,
		action_weight = 1,
		start_anims_name = {
			bwd = "run",
			fwd = "run",
			left = "run",
			right = "run"
		},
		start_anims_data = {
			alerted_fwd = {},
			alerted_bwd = {
				dir = -1,
				rad = math.pi
			},
			alerted_left = {
				dir = 1,
				rad = math.pi / 2
			},
			alerted_right = {
				dir = -1,
				rad = math.pi / 2
			}
		}
	},
	flee = {
		min_far_along_path_pos_distance_sq = 100,
		considerations = UtilityConsiderations.clan_rat_follow,
		cover_point_check = {
			max_height_diff = 2,
			max_cover_point_check_dist = 25,
			min_cover_point_check_dist = 5
		},
		random_point_in_front_check = {
			max_random_point_in_front_check_dist = 15,
			below = 2,
			min_width = 1,
			max_tries = 30,
			max_width = 5,
			above = 1,
			min_random_point_in_front_check_dist = 10
		},
		random_point_check = {
			below = 2,
			max_tries = 30,
			min_random_point_check_dist = 5,
			above = 1,
			max_random_point_check_dist = 10
		},
		dig_timer = {
			max_time_before_dig = 10,
			min_time_before_dig = 5
		}
	},
	look_for_players = {
		anim_event = "idle",
		despawn_radius = 30,
		anim_length = 4,
		look_time = 2
	},
	idle = {}
}

return