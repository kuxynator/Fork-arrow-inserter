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

function create_item(info)
	local base_name = info.base_name or nil
	local prefix = info.prefix
	local tint = info.tint
	local tags = info.tags or {
		long = false,
		stack = false
	}

	local name = prefix .. "arrow"
	if not mods["bobinserters"] then
		name = tag_name(name, tags)
	end

	local iBase = table.deepcopy(data.raw.item[base_name]) or table.deepcopy(data.raw.item[prefix .. "inserter"])
	iBase.name = name
	iBase.place_result = name
	iBase.localised_name = { "item-name." .. iBase.name }
	iBase.order = "z[arrow]-[" .. name .. "]"
	iBase.icons = { {
		icon = "__arrow-inserter__/arrow.png",
		icon_size = 64,
		tint = tint
	} }
	data:extend { iBase }
end

return {
	create_item = create_item,
}
