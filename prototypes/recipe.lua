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

local function create_recipe(prefix)
	local name = prefix .. "arrow"

	local rBase = table.deepcopy(data.raw.recipe[prefix .. "inserter"])

	rBase.name = name
	rBase.result = name
	rBase.enabled = true

	data:extend { rBase }
end

return {
	create_recipe = create_recipe,
}
