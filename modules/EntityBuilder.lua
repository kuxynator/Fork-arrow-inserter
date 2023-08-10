require("modules/Utils")
EntityBuilder = {}

local platform_picture_path = "__arrow-inserter__/graphics/"..settings.startup["arrow-platform-picture"].value..".png"
local icon="__arrow-inserter__/graphics/arrow.png"

local function constants(eBase, tint, energy)
	eBase.icons = { {
		icon = icon,
		icon_size = 64,
		tint = tint
	} }
	eBase.selection_priority = 255
	eBase.rotation_speed = eBase.rotation_speed / 100 * 120 -- HACK: de-nerf
	eBase.energy_per_rotation = energy.active or eBase.energy_per_rotation
	eBase.energy_source.drain = energy.passive or eBase.energy_source.drain
	eBase.allow_custom_vectors = true -- HACK: allow bobinserters configuration
	eBase.pickup_position = { 0, -0.5 }
	eBase.insert_position = { -0.001, 0.5 } --HACK: { 0, 0.35 } 
	eBase.collision_box = nil --HACK: { { -0.25, -0.01 }, { 0.25, 0.01 } }
	eBase.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
	eBase.collision_mask = { "item-layer", "object-layer", "player-layer", }
	eBase.flags = { "placeable-neutral", "placeable-player", "player-creation" }
	eBase.fast_replaceable_group = "arrow"
	eBase.next_upgrade = ""
	eBase.protected_from_tile_building = false
	eBase.tile_height = 0
	eBase.tile_width = 1
	eBase.draw_inserter_arrow = true -- HACK: (false)
	eBase.draw_held_item = false --HACK:
	eBase.chases_belt_items = false
	eBase.hand_size = 0.05
	eBase.hand_base_picture = Utils.empty_sheet
	eBase.hand_base_shadow = Utils.empty_sheet
	eBase.hand_closed_picture = Utils.empty_sheet
	eBase.hand_closed_shadow = Utils.empty_sheet
	eBase.hand_open_picture = Utils.empty_sheet
	eBase.hand_open_shadow = Utils.empty_sheet
	eBase.platform_picture.sheet.scale = 0.5
	eBase.platform_picture.sheet.size = 64
	eBase.platform_picture.sheet.shift = { 0, 0 }
	eBase.platform_picture.sheet.filename = platform_picture_path
	eBase.platform_picture.sheet.tint = tint
	eBase.platform_picture.sheet.hr_version.size = 64
	eBase.platform_picture.sheet.hr_version.shift = { 0, 0 }
	eBase.platform_picture.sheet.hr_version.tint = tint
	eBase.platform_picture.sheet.hr_version.filename = platform_picture_path
	--HACK: disabled feature
	-- if settings.startup["add-one-filter-slot"].value then
	-- 	eBase.filter_count = 1
	-- 	eBase.filter_mode = "blacklist"
	-- end
end

local function tag_works(eBase, tags)
	--HACK: new feature: separate filter inserter	
	if tags.filter then
		eBase.filter_count = 1
		if not eBase.name:find("filter-") then
			eBase.name = "filter-" .. eBase.name
		end
	end
	if tags.long then
		eBase.pickup_position = { 0, -1.5 }
		eBase.insert_position = { -0.2, 1.35 } --HACK:{ 0, 1.35 }
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

function EntityBuilder.create_entity(preset)
	local base_name = preset.base_name or nil
	local prefix = preset.prefix
	local name = prefix .. "arrow"
	local tint = preset.tint
	local energy = preset.energy

	local eBase = table.deepcopy(data.raw.inserter[base_name])
			or table.deepcopy(data.raw.inserter[prefix .. "inserter"])

	local tags = preset.tags or {
		filter = false, --HACK: new feature
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

	--HACK: disable extra inserters 
	if false and mods["bobinserters"] then
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

	EntityBuilder.create_constant_combinator(eBase, tint)
	data:extend { eBase }
end

function EntityBuilder.create_constant_combinator(parent, tint)
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
		--filename = platform_picture_path,
		filename=parent.platform_picture.sheet.filename,
		size = { 1, 1 },
		position = { 0, 0 },
		tint = tint,
		scale = 0.5,
	} }
	entity.integration_patch = { sheet = {
		--filename = platform_picture_path,
		filename=parent.platform_picture.sheet.filename,
		size = 64,
		position = { 0, 0 },
		tint = tint,
		scale = 0.5,
	} }
	data:extend { entity }
end

return EntityBuilder
