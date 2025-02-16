local uuid = require("uuid")
local bcrypt = require("bcrypt")
local success_response = require("src.helpers.success_response")
local error_response = require("src.helpers.error_response")
local User = require("src.models.User")
local create_token = require("src.services.auth.helpers.create_token")

local M = {}

M.login_user = function(email, password)
	local user = User:find({ email = email })

	if not user then
		return error_response(404, "User Not Found", "No account exists with the provided email.")
	end

	local is_authenticated = bcrypt.verify(password, user.password)
	if not is_authenticated then
		return error_response(401, "Unauthorized", "The provided password is incorrect. Please try again")
	end

	local access_token = create_token({ user_id = user.id, username = user.username }, 10) -- Validity 10 Mins
	local refresh_token = create_token({ user_id = user.id, username = user.username }, 360) -- Validity 6 Hours
	local current_time = os.time()

	local is_mutation_success = user:update({ refresh_token = refresh_token, updated_at = current_time })

	if not is_mutation_success then
		return error_response(500, "Internal Server Error", "Failed to update user record")
	end

	return success_response(200, {
		message = string.format("Welcome back, %s!", user.username),
		access_token = access_token,
		refresh_token = refresh_token,
	})
end

M.register_new_user = function(username, email, password)
	-- Check if username already exists
	local existing_user = User:select("WHERE username = ? OR email = ?;", username, email)

	if next(existing_user) ~= nil then
		return error_response(
			409,
			"Conflict",
			"The username or email is already in use. Please choose a different one."
		)
	end

	local user_id = uuid.v4()
	local hashed_password = bcrypt.digest(password, 9) -- 9 is salt rounds
	local access_token = create_token({ user_id = user_id, username = username }, 10)
	local refresh_token = create_token({ user_id = user_id, username = username }, 360)
	local current_time = os.time()

	local new_user = User:create({
		id = user_id,
		username = username,
		email = email,
		password = hashed_password,
		refresh_token = refresh_token,
		created_at = current_time,
		updated_at = current_time,
	})

	if not new_user then
		return error_response(500, "Internal Server Error", "Failed to create new user")
	end

	return success_response(
		201,
		{ user_id = user_id, username = username, access_token = access_token, refresh_token = refresh_token }
	)
end

return M
