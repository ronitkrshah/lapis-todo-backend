local valid = require("src.modules.valid")

local create_todo_validation = valid.map({
	required = { "title" },
	table = {
		title = valid.string(),
		description = valid.string(),
	},
})

return create_todo_validation
