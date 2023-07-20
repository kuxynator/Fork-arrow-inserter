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

local function constants(eBase, tint, energy)
	eBase.icons = { {
		icon = "__arrow-inserter__/arrow.png",
		icon_size = 64,
		tint = tint
	} }
	eBase.selection_priority = 255
	eBase.rotation_speed = eBase.rotation_speed * 4 / 5
	eBase.energy_per_rotation = energy.active or eBase.energy_per_rotation
	eBase.energy_source.drain = energy.passive or eBase.energy_source.drain
	eBase.allow_custom_vectors = true --HACK:Kux 'true' is required for bobinserters, mod default: false
	eBase.pickup_position = { 0, -0.5 }
	eBase.insert_position = { -0.05, 0.35 }
	eBase.collision_box = { { -0.25, -0.01 }, { 0.25, 0.01 } }
	eBase.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
	eBase.collision_mask = { "item-layer", "object-layer", "player-layer", }
	eBase.flags = { "placeable-neutral", "placeable-player", "player-creation" }
	eBase.fast_replaceable_group = "arrow"
	eBase.next_upgrade = ""
	eBase.protected_from_tile_building = false
	eBase.tile_height = 0
	eBase.tile_width = 1
	eBase.draw_inserter_arrow = false
	eBase.chases_belt_items = false
	eBase.hand_size = 0.05
	eBase.hand_base_picture = empty_sheet
	eBase.hand_base_shadow = empty_sheet
	eBase.hand_closed_picture = empty_sheet
	eBase.hand_closed_shadow = empty_sheet
	eBase.hand_open_picture = empty_sheet
	eBase.hand_open_shadow = empty_sheet
	eBase.platform_picture.sheet.scale = 0.5
	eBase.platform_picture.sheet.size = 64
	eBase.platform_picture.sheet.hr_version.size = 64
	eBase.platform_picture.sheet.shift = { 0, 0 }
	eBase.platform_picture.sheet.hr_version.shift = { 0, 0 }
	eBase.platform_picture.sheet.filename = "__arrow-inserter__/arrow.png"
	eBase.platform_picture.sheet.tint = tint
	eBase.platform_picture.sheet.hr_version.tint = tint
	eBase.platform_picture.sheet.hr_version.filename = "__arrow-inserter__/arrow.png"
	if settings.startup["add-one-filter-slot"].value then
		eBase.filter_count = 1
	end
end

local function tag_works(eBase, tags)
	if tags.long then
		eBase.pickup_position = { 0, -1.5 }
		eBase.insert_position = { 0, 1.35 }
		if not eBase.name:find("long-") then
			eBase.name = "long-" .. eBase.name
		end
	end
	if tags.stack then
		eBase.stack = true
		if not eBase.name:find("stack-") then
			eBase.name = "stack-" .. eBase.name
		end
	end
	return eBase
end

local function local_name(eBase)
	eBase.localised_name = { "entity-name." .. eBase.name }
end

local function create_entity(info)
	local base_name = info.base_name or nil
	local prefix = info.prefix
	local name = prefix .. "arrow"
	local tint = info.tint
	local energy = info.energy

	local eBase = table.deepcopy(data.raw.inserter[base_name])
			or table.deepcopy(data.raw.inserter[prefix .. "inserter"])

	local tags = info.tags or {
		long = false,
		stack = false
	}

	eBase.name = name
	eBase.minable.result = name
	eBase.order = "z[arrow]-[" .. name .. "]"

	constants(eBase, tint, energy)
	local_name(eBase)

	if mods["Squeak Through"] then
		eBase.collision_mask[3] = nil
	end

	if mods["bobinserters"] then
		eBase.placeable_by = { item = eBase.name, count = 1 }
		local tmp = table.deepcopy(eBase)
		tag_works(tmp, { long = true })
		local_name(tmp)
		data:extend { tmp }
		tmp = table.deepcopy(eBase)
		tag_works(tmp, { stack = true })
		local_name(tmp)
		data:extend { tmp }
		tmp = table.deepcopy(eBase)
		tag_works(tmp, { long = true, stack = true })
		local_name(tmp)
		data:extend { tmp }
	end

	tag_works(eBase, tags)

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
