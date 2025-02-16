local ApiController = require("src.utilities.ApiController")
local request_body_validation_middleware = require("src.middlewares.request_body_validation_middleware")
local login_validation = require("src.validations.auth.login_validation")
return function(app)
	local controller = ApiController:create({ route = "/auth" }, app)

	-- Login POST Request
	controller:http_post("/login", { request_body_validation_middleware(login_validation) }, function(_, body) end)
end
