local entities = require("prototypes.entity")
local items = require("prototypes.item")
local recipes = require("prototypes.recipe")

local num = 0

local function create(prefix, tint)
	entities.create_entity(prefix, tint, num)
	items.create_item(prefix, tint, num)
	recipes.create_recipe(prefix, tint, num)
	num = num + 1
end

create("", { r = 1.0, g = 1.0, b = 0.0 })
create("fast-", { r = 0.0, g = 0.5, b = 1.0 })
create("stack-", { r = 0.5, g = 1.0, b = 0.4 })
