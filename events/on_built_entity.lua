require("modules/Utils")
local this = {}


-- on_built_entity
-- on_robot_built_entity
-- script_raised_built
-- script_raised_revive
function this.on_built_entity(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	print("on_built_entity "..new_entity.name.." ("..new_entity.unit_number ..") ["..Utils.evt_displaynames[evt.name].."]")
	if(new_entity.name=="entity-ghost") then
		if(new_entity.prototype.name:match("%-arrow$")) then print("  skip: not an arrow ghost"); return end
	elseif not string.match(new_entity.name, "%-arrow$") then print("  skip: not an arrow"); return end

	if(new_entity.name=="entity-ghost") then this.on_built_inserter_ghost(evt);return end
	if(new_entity.name:match("%-double%-arrow$")) then this.on_built_double_arrowy(evt); return end
	-- create_arrow(entity.name, entity, entity.direction)

	-- Überprüfen, ob es bereits einen Inserter auf dem Tile gibt
	local existingEntities = new_entity.surface.find_entities_filtered{position = new_entity.position}
	local existingInserters={}; for _, ee in ipairs(existingEntities) do
		print("  ?"..ee.name.." ("..ee.unit_number ..")")
		if(ee.name:match("%-arrow$") and ee.unit_number ~=new_entity.unit_number) then table.insert(existingInserters,ee) end
	end

	if #existingInserters == 0 then
		print("  empty")
		this.create_arrow(new_entity)
	elseif #existingInserters == 1 then
		print("  existing "..new_entity.name)
		local force = new_entity.force
		local position = new_entity.position;
		local direction = new_entity.direction;
		local surface = new_entity.surface
		local prefix = new_entity.name:sub(1,-6)
		this.remove_arrow(existingInserters[1]); existingInserters[1].destroy();
		new_entity.destroy()

		new_entity = surface.create_entity { name = prefix.."l-arrow", position = position, direction = direction, fast_replace = true, force = force, spill = false }
		this.create_arrow(new_entity)
		new_entity = surface.create_entity { name = prefix.."r-arrow", position = position, direction = direction, fast_replace = true, force = force, spill = false }
		this.create_arrow(new_entity)

	elseif #existingInserters >= 2 then
		print("  full")
		local surface = new_entity.surface
		local position = new_entity.position;
		local name = new_entity.name
		Entity.deconstruct(new_entity, evt)
	end

	--- HACK: Kuxynator
	--- blacklist the inserter if no filter is defined
	--- draw back: inserter without filter which is intentionally whitelisted will be changed
	-- HACK: no longer necessary --
	-- local hasFilter=false
	-- for i = 1, entity.prototype.filter_count do
	-- 	local filter = entity.get_filter(i)
	-- 	if(filter) then hasFilter=true;break end
	-- end
	-- if(not hasFilter) then entity.inserter_filter_mode="blacklist" end
    ::continue::
end

---------------------------------------------------------------------------------------------------

function this.on_built_double_arrowy(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	print("on_built_double_arrowy")

	local part_ghost=this.find_part_ghost(new_entity)	

	this.remove_any_other(new_entity)
	this.create_part(new_entity, part_ghost)
	this.create_arrow(new_entity)
end

function this.on_built_inserter_ghost(evt)
	local new_entity = Utils.get_entity[evt.name](evt)
	print("  ghost: "..new_entity.ghost_name)
	--print("  "..Entity.dump(new_entity))

	--if(new_entity.ghost_name:match("%-double%-arrow$")) then return end --nothing to do

	local prefix = new_entity.ghost_name:match("^(.-%-)[lr]%-arrow$")
	if(prefix) then -- prefix- (l-arrow|r-arrow)
		print("  sub inserter")
		this.create_slim_inserter_ghost(new_entity)
		new_entity.destroy()
	end
end

---------------------------------------------------------------------------------------------------

function this.create_arrow(inserter)
	local name = inserter.name
	if false --[[HACK: feature disabled]] and game.active_mods["bobinserters"] then
		name = name:gsub("long%-", "")
		name = name:gsub("stack%-", "")
	end
	local arr = inserter.surface.create_entity {
		name      = name .. "_arr",
		position  = inserter.position,
		direction = (inserter.direction + 4) % 8,
		force     = inserter.force,
		type      = "constant-combinator"
	}
	arr.destructible = false
	return arr
end

---Creates a new inserter part, using the properties from the ghost if specified.
---@param inserter LuaEntity
---@param ghost LuaEntity?
function this.create_part(inserter, ghost)
	local name = inserter.name
	---@diagnostic disable-next-line: missing-fields
	local part = inserter.surface.create_entity {
		name      = name .. "_part",
		position  = inserter.position,
		direction = inserter.direction,
		force     = inserter.force,
		type      = "inserter"
	}
	if(ghost) then
		Entity.copy_inserter_properties(ghost, part)
		ghost.destroy()
	end
	return part
end

function this.create_slim_inserter_ghost(new_entity)
	local prefix = new_entity.ghost_name:match("^(.-%-)[lr]%-arrow$")
	local replacement = {
		name         = "entity-ghost",
		position     = new_entity.position,
		direction    = new_entity.direction,
		force        = new_entity.force.name,
		fast_replace = false, -- If true, building will attempt to simulate fast-replace building. If false, it will fail if any non-colliding entities would be destroyed.
		spill        = false, -- If false while fast_replace is true and player is nil any items from fast-replacing will be deleted instead of dropped on the ground.
		raise_built  = false, -- If true; defines.events.script_raised_built will be fired on successful entity creation.
		inner_name   = prefix.."arrow",
	}
	if(new_entity.surface.can_place_entity(replacement) == false) then print("  can't place entity"); return end
	local ghost = new_entity.surface.create_entity(replacement)
	Entity.copy_inserter_properties(new_entity, ghost)
	--print("  ghost: "..Entity.dump(ghost))
end

this.find_part_ghost = function(entity)
	local list = entity.surface.find_entities_filtered { position = entity.position, name = "entity-ghost" }
	for _, ghost in ipairs(list) do
		if(ghost.ghost_name==entity.name.."_part") then return ghost end
	end
	return nil
end

function this.remove_arrow(inserter)
	local name = inserter.name
	if false --[[HACK: feature disabled]] and game.active_mods["bobinserters"] then
		name = name:gsub("long%-", "")
		name = name:gsub("stack%-", "")
	end
	local arr_list = inserter.surface.find_entities_filtered { position = inserter.position, type = "constant-combinator",name=name.."_arr" }
	for _, arr in ipairs(arr_list) do
		arr.destroy()
	end
end

function this.remove_any_other(inserter, e)
	local function destroy(entity)
		print("  ⊗ "..entity.name)
		entity.destroy()
	end

	local list = inserter.surface.find_entities_filtered { position = inserter.position }
	for _, entity in ipairs(list) do
		if(entity.unit_number == inserter.unit_number) then ;--skip
		elseif(entity.name:match("entity-ghost")) then destroy(entity)
		elseif(entity.name:match("%-arrow_arr$")) then destroy(entity)
		elseif(entity.name:match("%-double%-arrow_part$")) then destroy(entity)
		elseif(entity.name:match("%-arrow$")) then Entity.deconstruct(entity, e)
		else print("  ? "..entity.name) end
	end
end

---------------------------------------------------------------------------------------------------

--TODO: use filter!
script.on_event(defines.events.on_built_entity, this.on_built_entity)
script.on_event(defines.events.on_robot_built_entity, this.on_built_entity)
script.on_event(defines.events.script_raised_built, this.on_built_entity)
script.on_event(defines.events.script_raised_revive, this.on_built_entity)
