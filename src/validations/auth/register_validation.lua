local valid = require("src.modules.valid")

local register_validation = valid.map({
	required = { "email", "password", "username" },
	table = {
		username = valid.string({ minlen = 3 }),
		email = valid.string({ pattern = ".+@.+%..+" }),
		password = valid.string({ minlen = 6 }),
	},
})

return register_validation
