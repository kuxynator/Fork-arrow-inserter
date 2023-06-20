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

local function tag_name(name, tags)
	if tags.long and not name:find("long-") then
		name = "long-" .. name
	end
	if tags.stack and not name:find("stack-") then
		name = "stack-" .. name
	end
	return name
end

local count = 0

local function create_recipe(info)
	local base_name = info.base_name or nil
	local prefix = info.prefix
	local tint = info.tint
	local recipe = info.recipe
	local tags = info.tags or {
		long = false,
		stack = false
	}

	local name = prefix .. "arrow"
	if not mods["bobinserters"] then
		name = tag_name(name, tags)
	end

	local rBase = table.deepcopy(data.raw.recipe[base_name]) or table.deepcopy(data.raw.recipe[prefix .. "inserter"])

	rBase.name = name
	rBase.localised_name = { "entity-name." .. rBase.name }
	rBase.result = name
	rBase.order = "z[arrow]-" .. count .. "[" .. name .. "]"
	rBase.normal = nil
	rBase.expensive = nil
	rBase.ingredients = recipe[1] or rBase.ingredients
	rBase.result_count = recipe[2] or rBase.result_count
	rBase.icons = { {
		icon = "__arrow-inserter__/arrow.png",
		icon_size = 64,
		tint = tint
	} }

	count = count + 1
	data:extend { rBase }
end

return {
	create_recipe = create_recipe,
}
