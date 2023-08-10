require("modules/Utils")

ItemBuilder={}

function ItemBuilder.create_item(preset)
	local base_name = preset.base_name or nil
	local prefix = preset.prefix
	local tint = preset.tint
	local tags = preset.tags or {
		long = false,
		stack = false
	}

	local name = prefix .. "arrow"
	if not mods["bobinserters"] then --TOTO: revise
		name = Utils.tag_name(name, tags)
	end

	local iBase = table.deepcopy(data.raw.item[base_name]) or table.deepcopy(data.raw.item[prefix .. "inserter"])
	iBase.name = name
	iBase.place_result = name
	iBase.localised_name = { "item-name." .. iBase.name }
	if(name:find("double-")) then
		iBase.order = "z[double-arrow]-[" .. name .. "]"
		iBase.icons = { {
			icon = "__arrow-inserter__/graphics/double-arrow.png",
			icon_size = 64,
			tint = tint
		} }
	else
		iBase.order = "z[arrow]-[" .. name .. "]"
		iBase.icons = { {
			icon = "__arrow-inserter__/graphics/arrow.png",
			icon_size = 64,
			tint = tint
		} }
	end
	data:extend { iBase }
end

return ItemBuilder
