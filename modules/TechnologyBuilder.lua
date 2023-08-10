require("modules/Utils")
TechnologyBuilder ={}

function TechnologyBuilder.add_to_tech(preset)
	local prefix = preset.prefix
	local base_name = preset.base_name or prefix .. "inserter"
	local tags = preset.tags or {
		filter = false, --HACK: new feature
		long = false,
		stack = false
	}

	local name = prefix .. "arrow"
	if not mods["bobinserters"] then --TOTO: revise
		name = Utils.tag_name(name, tags)
	end

	local found = false
	local logTech =""
	for _, tech in pairs(data.raw.technology) do
		if found then break end
		if tech.effect ~= nil or tech.effects ~= nil then
			if tech.effect ~= nil then
				if tech.effect.type == "unlock-recipe" and tech.effect.recipe == base_name then
					tech.effects = { tech.effect, { type = "unlock-recipe", recipe = name } }
					tech.effect = nil
					found = true
					logTech = tech.name
				end
			else
				for _, effect in pairs(tech.effects) do
					if effect.type == "unlock-recipe" and effect.recipe == base_name then
						table.insert(tech.effects, { type = "unlock-recipe", recipe = name })
						found = true
						logTech = tech.name
					end
				end
			end
		end
	end
	local logFound="found in "..logTech; if not found then logFound = "not found" end
	log("add_to_tech: "..name.." ["..logFound.."]")
end

return TechnologyBuilder
