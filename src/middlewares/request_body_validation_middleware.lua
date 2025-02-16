local error_response = require("src.helpers.error_response")
return function(validation_func)
	-- `req` is the api request
	return function(req)
		local is_valid, _, _, path_val = validation_func(req.params)

		if not is_valid then
			error(
				error_response(
					400,
					"Bad Request",
					"The request body contains invalid or missing fields. Please check your input and try again.",
					path_val
				)
			)
		end
	end
end
