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

function create_item(prefix)
	local name = prefix .. "arrow"

	local iBase = table.deepcopy(data.raw.item[prefix .. "inserter"])
	iBase.name = name
	iBase.place_result = name
	iBase.icon = "__core__/graphics/empty.png"
	iBase.icon_size = 1
	data:extend { iBase }
end

return {
	create_item = create_item,
}
