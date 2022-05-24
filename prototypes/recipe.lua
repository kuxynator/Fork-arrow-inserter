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

local recipes = {
	[0] = {
		{ "inserter", 1 },
		{ "electronic-circuit", 1 }
	},
	[1] = {
		{ "fast-inserter", 1 },
		{ "steel-plate", 1 }
	},
	[2] = {
		{ "stack-inserter", 1 },
		{ "advanced-circuit", 1 }
	}
}

local function create_recipe(prefix, tint, num)
	local name = prefix .. "arrow"

	local rBase = table.deepcopy(data.raw.recipe[prefix .. "inserter"])

	rBase.name = name
	rBase.result = name
	rBase.result_count = 2
	rBase.order = "z[arrow]-" .. num
	rBase.enabled = true
	local r = recipes[num] or rBase.ingredients
	rBase.ingredients = r
	rBase.icons = { {
		icon = "__arrow-inserter__/arrow.png",
		icon_size = 64,
		tint = tint
	} }

	data:extend { rBase }
end

return {
	create_recipe = create_recipe,
}
