local function tag_name(name, tags)
	if tags.long and not name:find("long-") then
		name = "long-" .. name
	end
	if tags.stack and not name:find("stack-") then
		name = "stack-" .. name
	end
	return name
end

function add_to_tech(info)
	local prefix = info.prefix
	local base_name = info.base_name or prefix .. "inserter"
	local tags = info.tags or {
		long = false,
		stack = false
	}

	local name = prefix .. "arrow"
	if not mods["bobinserters"] then
		name = tag_name(name, tags)
	end

	local found = false
	for _, contains in pairs(data.raw.technology) do
		if found then break end
		if contains.effect ~= nil or contains.effects ~= nil then
			if contains.effect ~= nil then
				if contains.effect.type == "unlock-recipe" and contains.effect.recipe == base_name then
					contains.effects = { contains.effect, { type = "unlock-recipe", recipe = name } }
					contains.effect = nil
					found = true
				end
			else
				for _, effect in pairs(contains.effects) do
					if effect.type == "unlock-recipe" and effect.recipe == base_name then
						table.insert(contains.effects, { type = "unlock-recipe", recipe = name })
						found = true
					end
				end
			end
		end
	end
end

return {
	add_to_tech = add_to_tech,
}
