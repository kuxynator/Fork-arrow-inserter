local entities = require("prototypes.entity")
local items = require("prototypes.item")
local recipes = require("prototypes.recipe")
local tech = require('prototypes.technology')

local function create(info)
	entities.create_entity(info)
	items.create_item(info)
	recipes.create_recipe(info)
	tech.add_to_tech(info)
end

local preset = {}
preset.normie = {
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
	preset.normie.recipe[1][2][1] = "basic-circuit-board"
	preset.normie.recipe[1][2][2] = 2
end

preset.want_a_longer_one = {
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
	preset.want_a_longer_one.recipe[1][2][2] = 2
end
if mods["boblogistics"] or mods["bobinserters"] then
	preset.want_a_longer_one.tags = {}
	preset.want_a_longer_one.prefix = "red-"
end

preset.fast_one = {
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
	preset.fast_one.recipe[1][2][1] = "advanced-circuit"
	preset.fast_one.recipe[1][2][2] = 2
end
if mods["boblogistics"] or mods["bobinserters"] then
	preset.fast_one.prefix = "blue-"
end

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
	preset.strong_one.recipe[1][1][1] = "express-inserter"
	preset.strong_one.recipe[1][2][1] = "advanced-processing-unit"
	preset.strong_one.recipe[1][2][2] = 2
end
if mods["boblogistics"] or mods["bobinserters"] then
	preset.strong_one.prefix = "green-"
	preset.strong_one.tags = {}
end
if mods["boblogistics"] then
	preset.strong_one.base_name = "express-inserter"
end

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
create(preset.normie)
create(preset.want_a_longer_one)
create(preset.fast_one)
create(preset.strong_one)

-- kr2
if mods["Krastorio2"] then
	create(preset.fast_boi)
	if not (mods["boblogistics"] or mods["bobinserters"]) then
		create(preset.long_boi)
	end
end

if mods["boblogistics"] then
	create(preset.purple_one)
end
