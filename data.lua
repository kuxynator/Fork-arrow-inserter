local entities = require("prototypes.entity")
local items = require("prototypes.item")
local recipes = require("prototypes.recipe")


-- info have following structure:
--
-- info_name = {
-- 	base_name:														string, optional if prefix gives name of inserter on adding "inserter" in the end
-- 																				name of existing inserter to be used as base
--
-- 	prefix:																string, custom prefix, example: "example-prefix-007-"
--
-- 	tint = { r, g, b, a: optional }:			colors with range from 0 to 1
--
-- 	energy = { passive, active }:					string with "W"(energy/sec) or "J"(energy/tick) in end,
-- 																				with multipliers "k, M, G, T, P, E, Z, Y", each 1000 times higher that previous
--
-- 	recipe = {{														recipe_shortcut
-- 		{"ingridient-name-1", ingr_amount},
-- 		{"ingridient-name-2", ingr_amount}
-- 	}, output_amount }:
--
--
--	tags = {															toggles for special effects, every one is optional because short code is nice to read
--		long: bool
--	}:
-- }


local function create(info)
	entities.create_entity(info)
	items.create_item(info)
	recipes.create_recipe(info)
end

local preset = {
	normie = {
		prefix = "",
		tint = { r = 1.0, g = 1.0, b = 0.0 },
		energy = { passive = "150W", active = "4.5kJ" },
		recipe = { {
			{ "inserter", 1 },
			{ "electronic-circuit", 1 }
		}, 2 }
	},

	fast_one = {
		prefix = "fast-",
		tint = { r = 0.0, g = 0.5, b = 1.0 },
		energy = { passive = "200W", active = "6kJ" },
		recipe = { {
			{ "fast-inserter", 1 },
			{ "steel-plate", 1 }
		}, 2 }
	},

	strong_one = {
		prefix = "stack-",
		tint = { r = 0.5, g = 1.0, b = 0.4 },
		energy = { passive = "400W", active = "18kJ" },
		recipe = { {
			{ "stack-inserter", 1 },
			{ "advanced-circuit", 1 }
		}, 2 }
	},

	want_a_longer_one = {
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
}

create(preset.normie)
create(preset.fast_one)
create(preset.strong_one)
create(preset.want_a_longer_one)
