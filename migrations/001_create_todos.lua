local schema = require("lapis.db.schema")
local types = schema.types

return {
	[001] = function()
		schema.create_table("todos", {
			{ "id", types.integer },
			{ "todo", types.text },
			{ "is_completed", types.integer, default = 0 },
			"PRIMARY KEY (id)",
		})
	end,
}
