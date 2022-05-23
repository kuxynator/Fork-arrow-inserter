local empty_sheet = {
	filename = "__core__/graphics/empty.png",
	priority = "very-low",
	width = 1,
	height = 1,
}

function create_inserter(prefix, tint)
	local name = prefix + "arrow"

	local eBase = table.deepcopy(data.raw["inserter"][prefix + "inserter"])

	eBase.name = "arrow"
	eBase.minable.result = "arrow"

	eBase.name = name
	eBase.place_result = name
	eBase.icon = "__core__/graphics/empty.png"
	eBase.icon_size = 1
	eBase.selection_priority = 255
	eBase.extension_speed = 0
	eBase.rotation_speed = eBase.rotation_speed * 4 / 5
	eBase.allow_custom_vectors = true
	eBase.pickup_position = { 0, -0.3 }
	eBase.insert_position = { 0, 0.45 }
	eBase.collision_box = { { -0.25, -0.01 }, { 0.25, 0.01 } }
	eBase.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
	eBase.collision_mask = { "player-layer", }
	eBase.flags = { "placeable-neutral", "placeable-player", "player-creation" }
	eBase.fast_replaceable_group = "arrow"
	eBase.next_upgrade = ""
	eBase.protected_from_tile_building = false
	eBase.tile_height = 0
	eBase.tile_width = 1
	eBase.draw_inserter_arrow = false
	eBase.chases_belt_items = false
	eBase.draw_held_item = false
	eBase.hand_size = 0.66
	eBase.hand_base_picture = empty_sheet
	eBase.hand_base_shadow = empty_sheet
	eBase.hand_closed_picture = empty_sheet
	eBase.hand_closed_shadow = empty_sheet
	eBase.hand_open_picture = empty_sheet
	eBase.hand_open_shadow = empty_sheet
	eBase.platform_picture.sheet = empty_sheet
	eBase.platform_picture.sheet.filename = "__seamless-loader__/arrow.png"
	eBase.platform_picture.sheet.hr_version.filename = "__seamless-loader__/arrow.png"
	eBase.platform_picture.sheet.size = 64
	eBase.platform_picture.sheet.hr_version.size = 64


	data:extend { eBase }
end

function create_constant_combinator()
	table.deepcopy("constant-combinator")
end
