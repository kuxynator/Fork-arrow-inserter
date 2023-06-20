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
	if game.active_mods["bobinserters"] then
		arrow_name = arrow_name:gsub("long%-", "")
		arrow_name = arrow_name:gsub("stack%-", "")
	end
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

	if string.match(entity.name, "arrow") then
		local direction = entity.direction
		create_arrow(entity.name, entity, direction)
	end

	game.players[1].print(serpent.block {entity})
	if string.match(entity.name, "arrow") then
		local direction = entity.direction
		create_arrow(entity.name, entity, direction)
	end
end

function destroy_entity(evt)
	local entity = get_entity[evt.name](evt)
	if entity.name:find("arrow") then
		local a = game.players[1].surface.find_entities_filtered { position = entity.position, type = "constant-combinator" }
		if a[2] then a[2].destroy() end
		if a[1] then a[1].destroy() end
	end
end

function fix_positions(entity)
	local look = (entity.orientation * 4)
	local pOffset = 0.34765625
	local dOffset = 0.5
	if entity.prototype.inserter_drop_position[2] == 1.35 then
		pOffset = 1.34765625
		dOffset = 1.5
	end
	if look == 0 then
		entity.drop_position = { entity.position.x, entity.position.y + pOffset }
		entity.pickup_position = { entity.position.x, entity.position.y - dOffset }
	end
	if look == 1 then
		entity.drop_position = { entity.position.x - pOffset, entity.position.y }
		entity.pickup_position = { entity.position.x + dOffset, entity.position.y }
	end
	if look == 2 then
		entity.drop_position = { entity.position.x, entity.position.y - pOffset }
		entity.pickup_position = { entity.position.x, entity.position.y + dOffset }
	end
	if look == 3 then
		entity.drop_position = { entity.position.x + pOffset, entity.position.y }
		entity.pickup_position = { entity.position.x - dOffset, entity.position.y }
	end
end

local function check_positions(entity)
	local xCheck = math.abs(entity.drop_position.x - entity.pickup_position.x)
	local yCheck = math.abs(entity.drop_position.y - entity.pickup_position.y)
	if (((entity.orientation * 4) % 2 == 1 and xCheck ~= 0.84765625 and xCheck ~= 2.84765625)
			or ((entity.orientation * 4) % 2 == 0 and yCheck ~= 0.84765625 and yCheck ~= 2.84765625))
			and entity.active
	then
		fix_positions(entity)
	end
end

local function long_stack_next(entity)
	local eName = entity.prototype.items_to_place_this[1].name
	local direction = entity.direction
	local position = entity.position
	local force = entity.force
	local surface = entity.surface
	surface.create_entity { name = "" .. eName, position = position, direction = direction, fast_replace = true,
		force = force, spill = false }
end

local function norm_next(entity)
	if entity.force.technologies["long-inserters-1"].researched then
		local eName = entity.prototype.items_to_place_this[1].name
		local direction = entity.direction
		local position = entity.position
		local force = entity.force
		local surface = entity.surface
		surface.create_entity { name = "long-" .. eName, position = position, direction = direction, fast_replace = true,
			force = force, spill = false }
	end
end

local function long_next(entity)
	if entity.force.technologies["more-inserters-1"].researched then
		local eName = entity.prototype.items_to_place_this[1].name
		local direction = entity.direction
		local position = entity.position
		local force = entity.force
		local surface = entity.surface
		surface.create_entity { name = "stack-" .. eName, position = position, direction = direction, fast_replace = true,
			force = force, spill = false }
	else
		long_stack_next(entity)
	end
end

local function stack_next(entity)
	if entity.force.technologies["long-inserters-2"].researched then
		local eName = entity.prototype.items_to_place_this[1].name
		local direction = entity.direction
		local position = entity.position
		local force = entity.force
		local surface = entity.surface
		surface.create_entity { name = "stack-long-" .. eName, position = position, direction = direction, fast_replace = true,
			force = force, spill = false }
	else
		long_stack_next(entity)
	end
end

local function picker_dollies_compat()
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then
		script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), function(evt)
			local entity = evt.moved_entity
			local pos = evt.start_pos
			if entity.name:find("arrow") then
				local a = game.players[1].surface.find_entities_filtered { position = pos, type = "constant-combinator" }[1]
				if a then
					a.destroy()
					build_entity { name = 4, entity = entity }
				end
			end
		end)
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
	if entity and entity.type == "inserter" and string.match(entity.name, "arrow") then
		check_positions(entity)
	end
end)

script.on_event(defines.events.on_gui_closed, function(evt)
	local entity = evt.entity
	if entity and entity.type == "inserter" and string.match(entity.name, "arrow") then
		check_positions(entity)
	end
end)

script.on_event(defines.events.on_player_rotated_entity, function(evt)
	local entity = evt.entity
	if string.find(entity.name, "arrow") then
		if not game.active_mods["bobinserters"] then
			entity.surface.find_entity(entity.name .. "_arr", entity.position).direction = (entity.direction + 4) % 8
			return
		end
		entity.direction = (entity.direction + 4) % 8

		local is_long = entity.name:find("long")
		local is_stack = entity.name:find("stack")
		if not is_long and not is_stack then
			norm_next(entity)
			return
		end
		if is_long and not is_stack then
			long_next(entity)
			return
		end
		if not is_long and is_stack then
			stack_next(entity)
			return
		end
		if is_long and is_stack then
			long_stack_next(entity)
			return
		end

	end
end)

script.on_load(function()
	picker_dollies_compat()
end)

script.on_init(function()
	picker_dollies_compat()
end)


-- game.players[1].print(serpent.block {})
-- game.players[1].print("hoi")
