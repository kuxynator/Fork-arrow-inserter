Utils = {}

Utils.empty_sheet = {
	filename = "__core__/graphics/empty.png",
	priority = "very-low",
	width = 1,
	height = 1,
	hr_version = {
		filename = "__core__/graphics/empty.png",
		priority = "very-low",
		width = 1,
		height = 1,
	}
}

--- stack- long- filter- double-
function Utils.tag_name(name, tags)
	if tags.double and not name:find("double-") then --TODO: new feature
		name = "double-" .. name
	end
	if tags.filter and not name:find("filter-") then --TODO: new feature
		name = "filter-" .. name
	end
	if tags.long and not name:find("long-") then
		name = "long-" .. name
	end
	if tags.stack and not name:find("stack-") then
		name = "stack-" .. name
	end
	return name	
end


Utils.get_entity = {
	[defines.events.on_player_mined_entity] = function(e) return e.entity end,
	[defines.events.on_built_entity       ] = function(e) return e.created_entity end,
	[defines.events.on_robot_built_entity ] = function(e) return e.created_entity end,
	[defines.events.script_raised_built   ] = function(e) return e.entity end,
	[defines.events.script_raised_revive  ] = function(e) return e.entity end,
	[defines.events.on_robot_mined_entity ] = function(e) return e.entity end,
	[defines.events.on_entity_died        ] = function(e) return e.entity end,
	[defines.events.script_raised_destroy ] = function(e) return e.entity end,
}

Utils.evt_displaynames={}
for key, value in pairs(defines.events) do Utils.evt_displaynames[value]=key.."("..value..")" end

Utils.filter = {
	{filter="name", name="yellow-arrow"},
	{filter="name", name="yellow-l-arrow"},
	{filter="name", name="yellow-r-arrow"},
	{filter="name", name="long-arrow"},
	{filter="name", name="long-l-arrow"},
	{filter="name", name="long-r-arrow"},
	{filter="name", name="fast-arrow"},
	{filter="name", name="fast-l-arrow"},
	{filter="name", name="fast-r-arrow"},
	{filter="name", name="filter-arrow"},
	{filter="name", name="filter-l-arrow"},
	{filter="name", name="filter-r-arrow"},
	{filter="name", name="stack-arrow"},
	{filter="name", name="stack-l-arrow"},
	{filter="name", name="stack-r-arrow"},
	{filter="name", name="stack-filter-arrow"},
	{filter="name", name="stack-filter-l-arrow"},
	{filter="name", name="stack-filter-r-arrow"},

	{filter="name", name="yellow-double-arrow"},
	{filter="name", name="yellow-double-arrow_part"},
	{filter="name", name="long-double-arrow"},
	{filter="name", name="long-double-arrow_part"},
	{filter="name", name="fast-double-arrow"},
	{filter="name", name="fast-double-arrow_part"},
	{filter="name", name="stack-double-arrow"},
	{filter="name", name="stack-double-arrow_part"},
	{filter="name", name="stack-filter-double-arrow"},
	{filter="name", name="stack-filter-double-arrow_part"},

	{filter="name", name="purple-arrow"},
	{filter="name", name="superior-arrow"},
}
