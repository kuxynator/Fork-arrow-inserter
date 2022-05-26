local get_entity = {
	[67] = function(evt) return evt.entity end,
	[6] = function(evt) return evt.created_entity end,
	[14] = function(evt) return evt.created_entity end,
	[79] = function(evt) return evt.entity end,
	[81] = function(evt) return evt.entity end,
	[66] = function(evt) return evt.entity end,
	[4] = function(evt) return evt.entity end,
	[80] = function(evt) return evt.entity end,
}

local function create_arrow(arrow_name, inserter, direction)
	local loader = inserter.surface.create_entity {
		name = arrow_name .. "_arr",
		position = inserter.position,
		direction = (direction + 4) % 8,
		force = inserter.force,
		type = "constant-combinator",
	}
	loader.destructible = false
	return loader
end

function build_entity(evt)
	local entity = get_entity[evt.name](evt)

	local direction = entity.direction
	if string.match(entity.name, "arrow") then
		create_arrow(entity.name, entity, direction)
		entity.inserter_stack_size_override = 1
		if string.match(entity.name, "stack") then
			entity.inserter_stack_size_override = 3
		end
	end
end

function destroy_entity(evt)
	local entity = get_entity[evt.name](evt)
	if string.find(entity.name, "arrow") then
		local a = entity.surface.find_entity(entity.name .. "_arr", entity.position)
		if a then a.destroy() end
	end
end

function fix_positions(entity)
	local look = (entity.orientation * 4)
	local offset = 0.34765625
	if entity.prototype.inserter_drop_position[2] == 0.65 then
		offset = 0.6484375
	end
	if look == 0 then
		entity.drop_position = { entity.position.x, entity.position.y + offset }
		entity.pickup_position = { entity.position.x, entity.position.y - 0.5 }
	end
	if look == 1 then
		entity.drop_position = { entity.position.x - offset, entity.position.y }
		entity.pickup_position = { entity.position.x + 0.5, entity.position.y }
	end
	if look == 2 then
		entity.drop_position = { entity.position.x, entity.position.y - offset }
		entity.pickup_position = { entity.position.x, entity.position.y + 0.5 }
	end
	if look == 3 then
		entity.drop_position = { entity.position.x + offset, entity.position.y }
		entity.pickup_position = { entity.position.x - 0.5, entity.position.y }
	end
end

script.on_event(defines.events.on_built_entity, build_entity)
script.on_event(defines.events.on_robot_built_entity, build_entity)
script.on_event(defines.events.script_raised_built, build_entity)
script.on_event(defines.events.script_raised_revive, build_entity)

script.on_event(defines.events.on_player_mined_entity, destroy_entity)
script.on_event(defines.events.on_robot_mined_entity, destroy_entity)
script.on_event(defines.events.on_entity_died, destroy_entity)
script.on_event(defines.events.script_raised_destroy, destroy_entity)

script.on_event(defines.events.on_selected_entity_changed, function(evt)
	local entity = evt.last_entity
	if entity and string.match(entity.name, "arrow") then

		-- game.players[1].print(serpent.block { { entity.drop_position.x - entity.position.x, entity.drop_position.y - entity.position.y }, { entity.pickup_position.x - entity.position.x, entity.pickup_position.y - entity.position.y } })
		local xCheck = math.abs(entity.drop_position.x - entity.pickup_position.x)
		local yCheck = math.abs(entity.drop_position.y - entity.pickup_position.y)
		if ((entity.orientation * 4) % 2 == 1 and xCheck ~= 0.84765625 and xCheck ~= 1.1484375)
				or ((entity.orientation * 4) % 2 == 0 and yCheck ~= 0.84765625 and yCheck ~= 1.1484375)
		then
			fix_positions(entity)
			-- game.players[1].print("Don't change position parameters please :)")
		end

		if entity and string.match(entity.name, "arrow") then
			entity.inserter_stack_size_override = 1
			if string.match(entity.name, "stack") then
				entity.inserter_stack_size_override = 3
			end
		end
	end
end)

script.on_event(defines.events.on_gui_closed, function(evt)
	local entity = evt.entity
	if entity and string.match(entity.name, "arrow") then

		local xCheck = math.abs(entity.drop_position.x - entity.pickup_position.x)
		local yCheck = math.abs(entity.drop_position.y - entity.pickup_position.y)
		if (((entity.orientation * 4) % 2 == 1 and xCheck ~= 0.84765625 and xCheck ~= 1.1484375)
				or ((entity.orientation * 4) % 2 == 0 and yCheck ~= 0.84765625 and yCheck ~= 1.1484375))
				and entity.active
		then
			fix_positions(entity)
			-- game.players[1].print("Don't change position parameters please :)")
		end

		entity.inserter_stack_size_override = 1
		if string.match(entity.name, "stack") then
			entity.inserter_stack_size_override = 3
		end
	end
end)

script.on_event(defines.events.on_player_rotated_entity, function(evt)
	local entity = evt.entity
	if string.find(entity.name, "arrow") then
		entity.surface.find_entity(entity.name .. "_arr", entity.position).direction = (entity.direction + 4) % 8
	end
end)

-- game.players[1].print("hoi")
