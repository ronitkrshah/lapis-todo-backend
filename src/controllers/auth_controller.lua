local ApiController = require("src.utilities.ApiController")
local request_body_validation_middleware = require("src.middlewares.request_body_validation_middleware")
local login_validation = require("src.validations.auth.login_validation")
local auth_service = require("src.services.auth.auth_service")
local register_validation = require("src.validations.auth.register_validation")

return function(app)
	local controller = ApiController:create({ route = "/auth" }, app)

	-- Login POST Request
	controller:http_post("/login", { request_body_validation_middleware(login_validation) }, function(_, body)
		return auth_service.login_user(body.email, body.password)
	end)

	-- Register a new user
	controller:http_post("/register", { request_body_validation_middleware(register_validation) }, function(_, body)
		return auth_service.register_new_user(body.username, body.email, body.password)
	end)
end
