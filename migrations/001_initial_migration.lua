local schema = require("lapis.db.schema")
local types = schema.types

return {
	up = function()
		-- Users Table
		schema.create_table("users", {
			{ "id", types.text },
			{ "username", types.text },
			{ "email", types.text },
			{ "password", types.text },
			{ "refresh_token", types.text, { null = true } },
			{ "created_at", types.text },
			{ "updated_at", types.text },
			"PRIMARY KEY (id)",
			"UNIQUE (username)",
			"UNIQUE (email)",
		})
		-- Todos Table
		schema.create_table("todos", {
			{ "id", types.text },
			{ "title", types.text },
			{ "description", types.text, null = true },
			{ "status", types.text, default = "pending" },
			{ "user_id", types.text },
			{ "completed_on", types.text },
			{ "created_at", types.text },
			{ "updated_at", types.text },
			"PRIMARY KEY (id)",
			"FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE",
		})
	end,
	down = function()
		schema.drop_table("todos")
		schema.drop_table("users")
	end,
}
