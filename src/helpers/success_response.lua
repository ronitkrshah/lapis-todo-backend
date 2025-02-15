return function(code, data)
	local is_code_number = type(code) == "number"

	return {
		status = is_code_number and code or 200,
		json = {
			success = true,
			status = "success",
			data = is_code_number and data or code,
		},
	}
end
