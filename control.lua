-- script.on_event(defines.events.on_built_entity,
-- 	function(event)
-- 	local player = game.get_player(event.player_index)
-- 	local entity = event.created_entity
-- 	local protoColl = entity.prototype.collision_box
-- 	local searchBox = { { entity.position.x + protoColl.left_top.x - 1, entity.position.y + protoColl.left_top.y - 1 }, { entity.position.x + protoColl.right_bottom.x + 1, entity.position.y + protoColl.right_bottom.y + 1 } }
-- 	local arrowsNear = game.surfaces["nauvis"].find_entities_filtered { area = searchBox, name = "slim-loader" } --serpent.dump()
-- 	if entity.name == "slim-loader" then
-- 		game.surfaces["nauvis"]["slim-loaders"].push(entity)
-- 	end
-- 	for _, arr in ipairs(arrowsNear) do

-- 	end
-- 	player.print("end")
-- end
-- )

-- script.on_event(defines.events.on_entity_died,
-- 	function(event)
-- 		local entity = event.entity
-- 		if entity.name == "slim-loader" then
-- 			game.surfaces["nauvis"]["slim-loaders"].push(entity)
-- 		end
-- 	end
-- )

-- script.on_event(defines.events.on_tick,
-- 	function(event)
-- 	local allArrows = game.surfaces["nauvis"].find_entities_filtered { name = "slim-loader" }
-- end)

script.on_event(defines.events.on_built_entity,
	function(event)
		local entity = event.created_entity
		if entity.name == "arrow" then
			entity.inserter_stack_size_override = 1
		end
	end)

script.on_event(defines.events.on_selected_entity_changed,
	function(event)
		local entity = event.last_entity
		if entity and entity.name == "arrow" then
			entity.inserter_stack_size_override = 1
		end
	end)

script.on_event(defines.events.on_gui_closed,
	function(event)
		local entity = event.last_entity
		if entity and entity.name == "arrow" then
			entity.inserter_stack_size_override = 1
		end
	end)

-- event.register(defines.events.on_built_entity, on_player_built)
-- event.register(defines.events.on_robot_built_entity, on_robot_built)
-- event.register(defines.events.on_player_rotated_entity, on_rotated)
