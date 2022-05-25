local empty_sheet = {
	filename = "__core__/graphics/empty.png",
	priority = "very-low",
	width = 1,
	height = 1,
	hr_version = {
		filename = "__core__/graphics/empty.png",
		priority = "very-low",
		width = 1,
		height = 1,
	}
}

local function create_entity(info)
	local base_name = info.base_name or nil
	local prefix = info.prefix
	local tint = info.tint
	local energy = info.energy
	local tags = info.tags

	local name = prefix .. "arrow"

	local eBase = table.deepcopy(data.raw["inserter"][base_name]) or table.deepcopy(data.raw["inserter"][prefix .. "inserter"])
	tags = tags or {
		long = false
	}

	eBase.name = name
	eBase.minable.result = name
	eBase.order = "z[arrow]-[" .. name .. "]"
	eBase.icons = { {
		icon = "__arrow-inserter__/arrow.png",
		icon_size = 64,
		tint = tint
	} }
	eBase.selection_priority = 255
	eBase.energy_per_rotation = energy.active or eBase.energy_per_rotation
	eBase.energy_source.drain = energy.passive or eBase.energy_source.drain
	eBase.rotation_speed = eBase.rotation_speed * 4 / 5
	eBase.allow_custom_vectors = true
	eBase.pickup_position = { 0, -0.5 }
	eBase.insert_position = { 0, 0.35 }
	if tags.long then
		eBase.insert_position = { 0, 0.65 }
	end
	eBase.collision_box = { { -0.25, -0.01 }, { 0.25, 0.01 } }
	eBase.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
	eBase.collision_mask = { "player-layer", }
	eBase.flags = { "placeable-neutral", "placeable-player", "player-creation" }
	eBase.fast_replaceable_group = "arrow"
	eBase.next_upgrade = ""
	eBase.protected_from_tile_building = false
	eBase.tile_height = 0
	eBase.tile_width = 1
	-- eBase.draw_inserter_arrow = false
	eBase.chases_belt_items = false
	-- eBase.draw_held_item = false
	eBase.hand_size = 0.05
	eBase.hand_base_picture = empty_sheet
	eBase.hand_base_shadow = empty_sheet
	eBase.hand_closed_picture = empty_sheet
	eBase.hand_closed_shadow = empty_sheet
	eBase.hand_open_picture = empty_sheet
	eBase.hand_open_shadow = empty_sheet
	eBase.platform_picture.sheet.size = 64
	eBase.platform_picture.sheet.hr_version.size = 64
	eBase.platform_picture.sheet.shift = { 0, 0 }
	eBase.platform_picture.sheet.hr_version.shift = { 0, 0 }
	eBase.platform_picture.sheet.filename = "__arrow-inserter__/arrow.png"
	eBase.platform_picture.sheet.hr_version.tint = tint
	-- eBase.platform_picture.sheet.hr_version.tint.a = 0.95
	eBase.platform_picture.sheet.hr_version.filename = "__arrow-inserter__/arrow.png"

	create_constant_combinator(eBase, tint)
	data:extend { eBase }
end

function create_constant_combinator(parent, tint)
	local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
	entity.name = parent.name .. "_arr"
	entity.collision_mask = {}
	entity.item_slot_count = 0
	entity.circuit_wire_max_distance = 0
	entity.integration_patch_render_layer = "higher-object-above"
	entity.collision_box = { { 0, 0 }, { 0, 0 } }
	entity.selection_box = { { 0, 0 }, { 0, 0 } }
	entity.tile_height = 0
	entity.tile_width = 1
	entity.sprites = { sheet = {
		filename = "__arrow-inserter__/arrow.png",
		size = { 1, 1 },
		position = { 0, 0 },
		tint = tint,
		scale = 0.5,
	} }
	entity.integration_patch = { sheet = {
		filename = "__arrow-inserter__/arrow.png",
		size = 64,
		position = { 0, 0 },
		tint = tint,
		scale = 0.5,
	} }
	data:extend { entity }
end

return {
	create_entity = create_entity,
}
