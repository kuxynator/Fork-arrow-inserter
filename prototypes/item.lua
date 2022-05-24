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

function create_item(prefix, tint, num)
	local name = prefix .. "arrow"

	local iBase = table.deepcopy(data.raw.item[prefix .. "inserter"])
	iBase.name = name
	iBase.place_result = name
	iBase.order = "z[arrow]-" .. num
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
