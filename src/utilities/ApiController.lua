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

-- Helper function to return route and a boolean that indicates is route a string
local function get_route(route, app)
	local is_route_string = type(route) == "string"
	local endpoint = string.format("/api/%s/%s", app.__api_version, app.__route)

	-- Check if any routes passed
	if is_route_string and route ~= "" then
		endpoint = endpoint .. "/" .. route
	end

	return endpoint, is_route_string
end

-- Get Method
function ApiController:http_get(route, req_handler)
	local api_endpoint, is_route_string = get_route(route, self)

	self.__app:get(
		api_endpoint,
		capture_errors(function(req)
			return is_route_string and req_handler(req) or route(req)
		end, exception_handler)
	)
end

-- Post Method
function ApiController:http_post(route, req_handler)
	local api_endpoint, is_route_string = get_route(route, self)

	self.__app:post(
		api_endpoint,
		capture_errors(
			json_params(function(req)
				local body = req.params
				return is_route_string and req_handler(req, body) or route(req, body)
			end),
			exception_handler
		)
	)
end

return ApiController
