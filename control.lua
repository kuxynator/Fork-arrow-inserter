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
		entity.surface.find_entity(entity.name .. "_arr", entity.position).destroy()
		game.players[1].print("hoi")
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
		entity.inserter_stack_size_override = 1
		if string.match(entity.name, "stack") then
			entity.inserter_stack_size_override = 3
		end
	end
end)

script.on_event(defines.events.on_gui_closed, function(evt)
	local entity = evt.entity
	if entity and string.match(entity.name, "arrow") then
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
		game.players[1].print("hoi")
	end
end)
