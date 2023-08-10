require("modules/EntityBuilder")
require("modules/ItemBuilder")
require("modules/RecipeBuilder")
require('modules/TechnologyBuilder')

local function create(preset)
	EntityBuilder.create_entity(preset)
	ItemBuilder.create_item(preset)
	RecipeBuilder.create_recipe(preset)
	TechnologyBuilder.add_to_tech(preset)
end

---@class Preset
---@field base_name string
---@field prefix string
---@field tint Color
---@field energy Energy
---@field recipe Recipe
---@field tags table<string, boolean>?

---@type Preset[]
local preset = {}

---@type Preset
preset.basic = {
	base_name = "inserter",
	prefix = "yellow-",
	tint = { r = 1.0, g = 1.0, b = 0.0 },
	energy = { passive = "150W", active = "4.5kJ" },
	recipe = { {
		{ "inserter", 1 },
		{ "electronic-circuit", 1 }
	}, 2 }
}
if mods["bobelectronics"] then
	preset.basic.recipe[1][2][1] = "basic-circuit-board"
	preset.basic.recipe[1][2][2] = 2
end

---@type Preset
preset.long = {
	base_name = "long-handed-inserter",
	prefix = "long-",
	tint = { r = 1.0, g = 0.2, b = 0.2 },
	energy = { passive = "150W", active = "4.5kJ" },
	recipe = { {
		{ "long-handed-inserter", 1 },
		{ "electronic-circuit", 1 }
	}, 2 },
	tags = { long = true }
}
if mods["bobelectronics"] then
	preset.long.recipe[1][2][2] = 2
end
if mods["boblogistics"] or mods["bobinserters"] then
	preset.long.tags = {}
	--HACK: preset.want_a_longer_one.prefix = "red-"
end

---@type Preset
preset.fast = {
	base_name = "fast-inserter",
	prefix = "fast-",
	tint = { r = 0.0, g = 0.5, b = 1.0 },
	energy = { passive = "200W", active = "6kJ" },
	recipe = { {
		{ "fast-inserter", 1 },
		{ "steel-plate", 1 }
	}, 2 }
}
if mods["bobelectronics"] then
	preset.fast.recipe[1][2] = {"advanced-circuit", 2}
end
if mods["boblogistics"] or mods["bobinserters"] then
	--HACK: preset.fast_one.prefix = "blue-"
end

---@type Preset
preset.filter = { --TODO: new feature
	base_name = "filter-inserter",
	prefix = "filter-",
	tint = { r = 0.698, g = 0.0, b = 1 },
	energy = { passive = "200W", active = "6kJ" },
	recipe = { {
		{ "filter-inserter", 1 },
		{ "steel-plate", 1 }
	}, 2 },
	tags = { filter = true }
}
if mods["bobelectronics"] then
	preset.fast.recipe[1][2][1] = "advanced-circuit"
	preset.fast.recipe[1][2][2] = 2
end 

---@type Preset
preset.strong_one = {
	base_name = "stack-inserter",
	prefix = "stack-",
	tint = { r = 0.5, g = 1.0, b = 0.4 },
	energy = { passive = "400W", active = "16kJ" },
	recipe = { {
		{ "stack-inserter", 1 },
		{ "advanced-circuit", 1 }
	}, 2 },
	tags = { stack = true }
}
if mods["bobelectronics"] then
	preset.strong_one.recipe[1][1] = {"express-inserter", 1}
	preset.strong_one.recipe[1][2] = {"advanced-processing-unit", 2}
end
if mods["boblogistics"] or mods["bobinserters"] then
	--HACK: preset.strong_one.prefix = "green-"
	preset.strong_one.tags = {}
end
if mods["boblogistics"] then
	preset.strong_one.base_name = "express-inserter"
end

---@type Preset
preset.strong_filter = { --TODO: new feature
	base_name = "stack-filter-inserter",
	prefix = "stack-filter-",
	tint = { r = 0.9, g = 0.9, b = 0.9 }, --white
	energy = { passive = "400W", active = "16kJ" },
	recipe = { {
		{ "stack-filter-inserter", 1 },
		{ "advanced-circuit", 1 }
	}, 2 },
	tags = { stack = true, filter = true }
}

---@type Preset
-- for boblogistics
preset.purple_one = {
	base_name = "turbo-inserter",
	prefix = "purple-",
	tint = { r = 0.4375, g = 0.0, b = 0.5 },
	energy = { passive = "400W", active = "16kJ" },
	recipe = { {
		{ "turbo-inserter", 1 },
		{ "processing-unit", 2 }
	}, 2 }
}

---@type Preset
---for K2
preset.fast_boi = {
	base_name = "kr-superior-inserter",
	prefix = "superior-",
	tint = { r = 0.15, g = 0.18, b = 0.2 },
	energy = { passive = "400W", active = "18kJ" },
	recipe = { {
		{ "kr-superior-inserter", 1 },
		{ "processing-unit", 1 }
	}, 2 }
}

---@type Preset
---for K2
preset.long_boi = {
	base_name = "kr-superior-long-inserter",
	prefix = "superior-long-",
	tint = { r = 0.35, g = 0.15, b = 0.18 },
	energy = { passive = "400W", active = "18.5kJ" },
	recipe = { {
		{ "kr-superior-long-inserter", 1 },
		{ "processing-unit", 1 }
	}, 2 },
	tags = { long = true }
}

-- vanilla
create(preset.basic)
create(preset.long)
create(preset.fast)
create(preset.filter) --HACK: new feature
create(preset.strong_one)
create(preset.strong_filter) --HACK: new feature

-- kr2
if mods["Krastorio2"] then
	create(preset.fast_boi)
	if not (mods["boblogistics"] or mods["bobinserters"]) then
		create(preset.long_boi)
	end
end

--HACK: feate disabled, we have the color purple already used for filter inserter
if false and mods["boblogistics"] then
	create(preset.purple_one)
end

-- because "Collision-box has to contain the [0,0] point." we can not put 2 entities on the same tile!
-- workaround: remove collision-box and handle collission manually

local function create_left(prefix)
	local entity = table.deepcopy(data.raw["inserter"][prefix.."arrow"])
	--entity.collision_box = { { -0.25, -0.01 }, { 0, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { -0.4, -0.2 }, { 0.0, 0.2 } }
	entity.name=prefix.."l-arrow"
	entity.subgroup = "inserter-sub-items"
	entity.fast_replaceable_group = "l-arrow"
	entity.platform_picture.sheet.filename = "__arrow-inserter__/graphics/arrow2-l.png"
	entity.platform_picture.sheet.hr_version.filename = "__arrow-inserter__/graphics/arrow2-l.png"
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 } entity.insert_position = { -0.20, 0.5 }
	
	local item = table.deepcopy(data.raw["item"][prefix.."arrow"])
	item.name=entity.name
	item.subgroup = "inserter-sub-items"
	item.place_result = entity.name


	local arrow = table.deepcopy(data.raw["constant-combinator"][prefix.."arrow_arr"])
	arrow.name = entity.name.."_arr"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,item,arrow}
end

local function create_right(prefix)
	local entity = table.deepcopy(data.raw["inserter"][prefix.."arrow"])
	--entity.collision_box = { { 0, -0.01 }, { 0.25, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { 0.0, -0.2 }, { 0.4, 0.2 } }
	entity.name=prefix.."r-arrow"
	entity.subgroup = "inserter-sub-items"
	entity.fast_replaceable_group = "r-arrow"
	entity.platform_picture.sheet.filename = "__arrow-inserter__/graphics/arrow2-r.png"
	entity.platform_picture.sheet.hr_version.filename = "__arrow-inserter__/graphics/arrow2-r.png"
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 } entity.insert_position = { 0.20, 0.5 }
	
	local item = table.deepcopy(data.raw["item"][prefix.."arrow"])
	item.name=entity.name
	item.subgroup = "inserter-sub-items"
	item.place_result = entity.name


	local arrow = table.deepcopy(data.raw["constant-combinator"][prefix.."arrow_arr"])
	arrow.name = entity.name.."_arr"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,item,arrow}
end

if(true) then --HACK: temporary feature "half inserter"
	create_left("yellow-");create_right("yellow-")
	create_left("long-");create_right("long-")
	create_left("fast-");create_right("fast-")
	create_left("filter-");create_right("filter-")
	create_left("stack-");create_right("stack-")
	create_left("stack-filter-");create_right("stack-filter-")
end

local function create_double(prefix)
	local entity = table.deepcopy(data.raw["inserter"][prefix.."arrow"])
	--entity.collision_box = { { -0.25, -0.01 }, { 0, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { -0.4, -0.2 }, { 0.0, 0.2 } }
	entity.name=prefix.."double-arrow"
	entity.fast_replaceable_group = "arrow"
	entity.platform_picture.sheet.filename = "__arrow-inserter__/graphics/double-arrow.png"
	entity.platform_picture.sheet.hr_version.filename = "__arrow-inserter__/graphics/double-arrow.png"
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 } entity.insert_position = { -0.20, 0.5 }

	local item = table.deepcopy(data.raw["item"][prefix.."arrow"])
	item.name=entity.name
	item.icons[1].icon = "__arrow-inserter__/graphics/double-arrow.png"

	item.place_result = entity.name

	local arrow = table.deepcopy(data.raw["constant-combinator"][prefix.."arrow_arr"])
	arrow.name = entity.name.."_arr"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,item,arrow}
end

local function create_doublepart(prefix)
	local entity = table.deepcopy(data.raw["inserter"][prefix.."arrow"])
	--entity.collision_box = { { 0, -0.01 }, { 0.25, 0.01 } }
	--entity.collision_mask =  {}
	--entity.collision_box = {{0,0}, {0,0}}
	entity.collision_box=nil
	entity.selection_box = { { 0.0, -0.2 }, { 0.4, 0.2 } }
	entity.name=prefix.."double-arrow_part"
	entity.fast_replaceable_group = "arrow"
	entity.platform_picture.sheet.filename = "__arrow-inserter__/graphics/double-arrow.png" --TODO use empty sprite
	entity.platform_picture.sheet.hr_version.filename = "__arrow-inserter__/graphics/double-arrow.png"--TODO use empty sprite
	-- entity.pickup_position = { -0.20, -0.5 } entity.insert_position = { -0.20, 0.5 }	
	-- FAIL: entity.tile_width = 0.5; entity.pickup_position = { 0, -0.5 }, 	entity.insert_position = { 0, 0.5 }
	entity.pickup_position = { 0, -0.5 } entity.insert_position = { 0.20, 0.5 }
	
	local item = table.deepcopy(data.raw["item"][prefix.."arrow"])
	item.name=entity.name
	item.icon = "__arrow-inserter__/graphics/double-arrow.png"
	item.subgroup = "inserter-sub-items"
	item.place_result = entity.name

	local arrow = table.deepcopy(data.raw["constant-combinator"][prefix.."arrow_arr"])
	arrow.name = entity.name.."_arr"
	arrow.sprites.sheet.filename = entity.platform_picture.sheet.filename
	arrow.integration_patch.sheet.filename = entity.platform_picture.sheet.filename

	data:extend{entity,item,arrow}
end

if(true) then --HACK: temporary feature "half inserter"
	create_double("yellow-");create_doublepart("yellow-")
	create_double("long-");create_doublepart("long-")
	create_double("fast-");create_doublepart("fast-")
	create_double("filter-");create_doublepart("filter-")
	create_double("stack-");create_doublepart("stack-")
	create_double("stack-filter-");create_doublepart("stack-filter-")
end

print("List of inserters:")
for key, value in pairs(data.raw.inserter) do
	if key:match("%-arrow") then print(key) end
end