local lapis = require("lapis")
local router = require("src.router")
local error_response = require("src.helpers.error_response")

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

-- Handle Unmatched Routes
app:get("/*", function()
	return error_response(
		404,
		"Route Not Found",
		"The requested endpoint does not exist. Please check the URL and try again."
	)
end)

return app
