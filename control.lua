require("lib/Entitiy")
local this = {}

local inserter_ghost_properties_to_copy = {
	"name", "position",
    "direction",
	"drop_position",
	"pickup_position",
    "force",
-- active
-- destructible
-- minable
-- rotatable
-- operable
-- health
-- direction
-- orientation
-- energy
-- tags
-- drop_position
-- pickup_position
-- drop_target
-- pickup_target
-- inserter_stack_size_override
-- entity_label
-- color
-- last_user
-- mining_progress
-- bonus_mining_progress
-- render_player
-- render_to_forces
}

function this.get_relative_pickup_position(entity) --HACK
	return {
		x = entity.pickup_position.x - entity.position.x,
		y = entity.pickup_position.y - entity.position.y
	}
end

function this.get_relative_drop_position(entity) --HACK
	return {
		x = entity.drop_position.x - entity.position.x,
		y = entity.drop_position.y - entity.position.y
	}
end

function this.fix_positions(entity)
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

function this.check_positions(entity)
	if(game.active_mods["bobinserters"]) then --HACK:
		-- I do not think we need to check this
		--local relPick = get_relative_pickup_position(entity)
		--local relDrop = get_relative_drop_position(entity)
		--print("check_positions {"..relPick.x..", "..relPick.y.."} -> {"..relDrop.x..", "..relDrop.y.."}")
	else
		local xCheck = math.abs(entity.drop_position.x - entity.pickup_position.x)
		local yCheck = math.abs(entity.drop_position.y - entity.pickup_position.y)
		if (((entity.orientation * 4) % 2 == 1 and xCheck ~= 0.84765625 and xCheck ~= 2.84765625)
				or ((entity.orientation * 4) % 2 == 0 and yCheck ~= 0.84765625 and yCheck ~= 2.84765625))
				and entity.active
		then
			this.fix_positions(entity)
		end
	end
end

function this.picker_dollies_compat()
	if not remote.interfaces["PickerDollies"] or not remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then return end

	local function on_dolly_moved_entity_id(e)
		local entity = e.moved_entity
		local pos = e.start_pos
		if entity.name:match("%-arrow$") then
			local list = entity.surface.find_entities_filtered { position = pos, type = "constant-combinator",name=entity.name.."_arr" }
			for _,a in ipairs(list) do a.destroy() end
			--this.on_built_entity { name = defines.events.on_entity_died, entity = entity } --TODO why on_entity_died ??
			this.create_arrow(entity)
		end
	end

	script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), on_dolly_moved_entity_id)
end

require("events/on_built_entity")
require("events/on_destroyed_entity")
require("events/on_player_rotated_entity")

script.on_event(defines.events.on_selected_entity_changed, function(evt)
	local entity = evt.last_entity
	if entity and entity.type == "inserter" and string.match(entity.name, "%-arrow$") then
		this.check_positions(entity)
	end
end)

script.on_event(defines.events.on_gui_closed, function(evt)
	local entity = evt.entity
	if entity and entity.type == "inserter" and string.match(entity.name, "%-arrow$") then
		this.check_positions(entity)
	end
end)

script.on_load(function()
	this.picker_dollies_compat()
end)

script.on_init(function()
	this.picker_dollies_compat()
end)

-- game.players[1].print(serpent.block {})
-- game.players[1].print("hoi")
