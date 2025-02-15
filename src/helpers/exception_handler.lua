local error_response = require("src.helpers.error_response")
return function(exception)
	return error_response(500, exception.errors[1])
end
