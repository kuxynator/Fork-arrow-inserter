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

local function create_recipe(info)
	local base_name = info.base_name or nil
	local prefix = info.prefix
	local tint = info.tint
	local recipe = info.recipe

	local name = prefix .. "arrow"

	local rBase = table.deepcopy(data.raw.recipe[base_name]) or table.deepcopy(data.raw.recipe[prefix .. "inserter"])

	rBase.name = name
	rBase.result = name
	rBase.order = "z[arrow]-[" .. name .. "]"
	rBase.enabled = true
	rBase.ingredients = recipe[1] or rBase.ingredients
	rBase.result_count = recipe[2] or rBase.result_count
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
