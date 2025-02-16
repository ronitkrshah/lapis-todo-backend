local json_params = require("lapis.application").json_params
local capture_errors = require("lapis.application").capture_errors
local exception_handler = require("src.helpers.exception_handler")

local ApiController = {}

local default_options = {
	api_version = "v1",
}

-- Create a new Api Controller
function ApiController:create(options, app)
	local obj = {
		__route = options.route,
		__api_version = options.api_version or default_options.api_version,
		__app = app,
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

-- Return a full api endpoint with base route and api version
local function get_full_api_endpoint(route, app)
	return string.format("/api/%s%s", app.__api_version, app.__route .. route)
end

-- Each middleware must throw an `error(error_response(code, "MSG")) if it fails
local function apply_middlewares(middlewares, req)
	for _, middleware in ipairs(middlewares) do
		local success, retval = pcall(middleware, req)
		if not success then
			return retval
		end
	end

	return true
end

-- Get Method
function ApiController:http_get(route, middlewares, req_handler)
	local api_endpoint = get_full_api_endpoint(route, self)

	self.__app:get(
		api_endpoint,
		capture_errors(function(req)
			local success = apply_middlewares(middlewares, req)

			if type(success) ~= "boolean" then
				-- Here succes contains error message
				return success
			end

			return req_handler(req)
		end, exception_handler)
	)
end

-- Post Method
function ApiController:http_post(route, middlewares, req_handler)
	local api_endpoint = get_full_api_endpoint(route, self)

	self.__app:post(
		api_endpoint,
		capture_errors(
			json_params(function(req)
				local body = req.params
				local success = apply_middlewares(middlewares, req)

				if type(success) ~= "boolean" then
					-- Here succes contains error message
					return success
				end
				return req_handler(req, body)
			end),
			exception_handler
		)
	)
end

return ApiController
