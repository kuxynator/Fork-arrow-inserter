local empty_sheet = {
	filename = "__core__/graphics/empty.png",
	priority = "very-low",
	width = 1,
	height = 1,
}

local basicarrow = {
	prefix = ""
}

function create_item(prefix)
	local name = prefix + "arrow"

	local iBase = table.deepcopy(data.raw.item[prefix + "inserter"])
	iBase.name = name
	iBase.place_result = name
	iBase.icon = "__core__/graphics/empty.png"
	iBase.icon_size = 1
	data:extend { iBase }
end

local iInserter = table.deepcopy(data.raw.item["inserter"])
local rInserter = table.deepcopy(data.raw.recipe["inserter"])
local eInserter = table.deepcopy(data.raw["inserter"]["inserter"])

iInserter.name = "arrow"
iInserter.place_result = "arrow"

rInserter.name = "arrow"
rInserter.enabled = true
rInserter.result = "arrow"

eInserter.name = "arrow"
eInserter.minable.result = "arrow"

eInserter.icon = "__core__/graphics/empty.png"
eInserter.icon_size = 1
eInserter.selection_priority = 255
-- eInserter.extension_speed = eInserter.extension_speed * 4 / 5
eInserter.rotation_speed = eInserter.rotation_speed * 4 / 5
eInserter.allow_custom_vectors = true
eInserter.pickup_position = { 0, -0.3 }
eInserter.insert_position = { 0, 0.45 }
eInserter.collision_box = { { -0.25, -0.01 }, { 0.25, 0.01 } }
eInserter.selection_box = { { -0.4, -0.2 }, { 0.4, 0.2 } }
eInserter.collision_mask = { "player-layer", }
eInserter.flags = { "placeable-neutral", "placeable-player", "player-creation" }
eInserter.fast_replaceable_group = "arrow"
eInserter.next_upgrade = ""
eInserter.protected_from_tile_building = false
eInserter.tile_height = 0
eInserter.tile_width = 1
eInserter.draw_inserter_arrow = false
eInserter.chases_belt_items = false
eInserter.draw_held_item = false
eInserter.hand_size = 0.66
eInserter.hand_base_picture = table.deepcopy(empty_sheet)
eInserter.hand_base_picture.hr_version = table.deepcopy(empty_sheet)
eInserter.hand_base_shadow = table.deepcopy(empty_sheet)
eInserter.hand_base_shadow.hr_version = table.deepcopy(empty_sheet)
eInserter.hand_closed_picture = table.deepcopy(empty_sheet)
eInserter.hand_closed_picture.hr_version = table.deepcopy(empty_sheet)
eInserter.hand_closed_shadow = table.deepcopy(empty_sheet)
eInserter.hand_closed_shadow.hr_version = table.deepcopy(empty_sheet)
eInserter.hand_open_picture = table.deepcopy(empty_sheet)
eInserter.hand_open_picture.hr_version = table.deepcopy(empty_sheet)
eInserter.hand_open_shadow = table.deepcopy(empty_sheet)
eInserter.hand_open_shadow.hr_version = table.deepcopy(empty_sheet)
-- eInserter.platform_picture.sheet = table.deepcopy(empty_sheet)
eInserter.platform_picture.sheet.x = 0
eInserter.platform_picture.sheet.width = 64
eInserter.platform_picture.sheet.height = 64
eInserter.platform_picture.sheet.hr_version.x = 0
eInserter.platform_picture.sheet.hr_version.width = 64
eInserter.platform_picture.sheet.hr_version.height = 64
eInserter.platform_picture.sheet.shift = { 0, 0 }
eInserter.platform_picture.sheet.hr_version.shift = { 0, 0 }
-- eInserter.platform_picture.sheet

eInserter.platform_picture.sheet.filename = "__seamless-loader__/arrow.png"
eInserter.platform_picture.sheet.hr_version.filename = "__seamless-loader__/arrow.png"


data:extend { iInserter, rInserter, eInserter }
