return function(code, message, details, exception_on)
	return {
		status = code or 500,
		json = {
			success = false,
			status = "failure",
			error = {
				message = message or "An unexpected error occurred",
				details = details or "No additional details available",
				exception_on = exception_on,
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
			},
		},
	}
end
