local lapis = require("lapis")
local router = require("src.router")

local app = lapis.Application()

app:get("/", function()
	return {
		json = {
			status = "success",
			message = "Welcome to the Lapis API!",
		},
	}
end)

router(app)

return app
