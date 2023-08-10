require("modules/Utils")
local this = {}

function this.on_destroyed_entity(evt)
	local old_entity = Utils.get_entity[evt.name](evt)
	--print("on_destroyed_entity "..old_entity.name) -- unit_number is not available
	--if not old_entity.name:match("%-arrow$") then print("  not an arrow") return end
	if not old_entity.name:match("%-arrow$") and not old_entity.name:match("%_arr$") and not old_entity.name:match("_part$") then return end
	print("on_destroyed_entity (filtered) "..old_entity.name.." ") -- unit_number is not available

	local name = old_entity.name:match("^(.-%-arrow)_part$")
	if(name) then -- is double inserter part
		local list = old_entity.surface.find_entities_filtered { position = old_entity.position, name=name }
		for _, inserter in ipairs(list) do
			print("  ⊗ "..inserter.name)
			inserter.destroy()
		end
	else -- is other inserter
		name = old_entity.name
		local part_list = old_entity.surface.find_entities_filtered { position = old_entity.position, name=name.."_part" }
		for _, part in ipairs(part_list) do
			print("  ⊗ "..part.name)
			part.destroy()
		end
	end

	--HACK: destroy only the _arr for the matching entity
	local arr_list = old_entity.surface.find_entities_filtered { position = old_entity.position, name=name.."_arr" }
	for _, arr in ipairs(arr_list) do
		print("  ⊗ "..arr.name)
		arr.destroy()
	end
	
	--TODO: support multiple inserters of same type?
end

--TODO: use filter!
script.on_event(defines.events.on_player_mined_entity, this.on_destroyed_entity)
script.on_event(defines.events.on_robot_mined_entity, this.on_destroyed_entity)
script.on_event(defines.events.on_entity_died, this.on_destroyed_entity)
script.on_event(defines.events.script_raised_destroy, this.on_destroyed_entity)
