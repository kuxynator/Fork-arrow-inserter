require("modules/Utils")

RecipeBuilder = {}

local icon = "__arrow-inserter__/graphics/arrow.png"
local count = 0

function RecipeBuilder.create_recipe(preset)
	local base_name = preset.base_name or nil
	local prefix = preset.prefix
	local tint = preset.tint
	local recipe = preset.recipe
	local tags = preset.tags or {
		long = false,
		stack = false
	}

	local name = prefix .. "arrow"
	if not mods["bobinserters"] then
		name = Utils.tag_name(name, tags)
	end

	local rBase = table.deepcopy(data.raw.recipe[base_name]) or table.deepcopy(data.raw.recipe[prefix .. "inserter"])

	rBase.name = name
	rBase.localised_name = { "entity-name." .. rBase.name }
	rBase.result = name
	if(name:find("double-")) then
		rBase.order = "z[double-arrow]-" .. count .. "[" .. name .. "]"
	else
		rBase.order = "z[arrow]-" .. count .. "[" .. name .. "]"
	end
	rBase.normal = nil
	rBase.expensive = nil
	rBase.ingredients = recipe[1] or rBase.ingredients
	rBase.result_count = recipe[2] or rBase.result_count
	rBase.icons = { {
		icon = icon,
		icon_size = 64,
		tint = tint
	} }

	count = count + 1
	data:extend { rBase }
end

return RecipeBuilder
