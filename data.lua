
data:extend({
	{
	  type = "recipe-category",
	  name = "sub-items"
	}
  })

  data:extend({
	{
	  type = "item-group",
	  name = "sub-items",
	  order = "z",
	  inventory_order = "z",
	  icon = "__core__/graphics/icons/category/unsorted.png",
	  icon_size = 128,
	},
	{
	  type = "item-subgroup",
	  name = "inserter-sub-items",
	  group = "sub-items",
	  order = "z",
	}
  })