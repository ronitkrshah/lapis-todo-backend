local jwt = require("resty.jwt")
local error_response = require("src.helpers.error_response")
local env = require("env")
return function(request)
	local auth_header = request.req.headers["Authorization"]

	if not auth_header then
		error(
			error_response(
				401,
				"Unauthorized",
				"Authentication token is missing. Please provide a valid Bearer token in the request header."
			)
		)
	end

	-- Extract the bearer token from the authorization header
	local bearer_token = auth_header:match("^Bearer%s+(.+)$")

	if not bearer_token then
		error(
			error_response(
				401,
				"Unauthorized",
				"Invalid authentication token. Please provide a valid Bearer token in the request header."
			)
		)
	end

	local jwt_obj = jwt:verify(env.JWT_SECRET_KEY, bearer_token)

	-- This will handle expiry and normal validations
	if not jwt_obj.verified then
		error(
			error_response(
				401,
				"Unauthorized",
				"Your authentication token is invalid or has expired. Please provide a valid token or log in again."
			)
		)
	end

	request.user = { user_id = jwt_obj.payload.user_id, username = jwt_obj.payload.username }
end
