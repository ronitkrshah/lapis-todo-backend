local valid = require("src.modules.valid")

local login_validation = valid.map({
	required = { "email", "password" },
	table = {
		email = valid.string({ pattern = ".+@.+%..+" }),
		password = valid.string({ minlen = 6 }),
	},
})

return login_validation
