local Todo = require("src.models.Todo")
local utils = require("lapis.util")
local json_patch = require("lua-jsonpatch")
local error_response = require("src.helpers.error_response")
local from_json, to_json = utils.from_json, utils.to_json

local M = {}

M.get_all_todos = function(user_id)
	return Todo:find({ user_id = user_id })
end

M.get_todo_by_id = function(user_id, id)
	local todo = Todo:find({ user_id = user_id, id = id })

	if not todo then
		return nil,
			error_response(
				404,
				"Resource Not Found",
				"The requested Todo with ID " .. id .. " was not found in the system."
			)
	end
	return todo
end

M.create_todo = function(todo)
	local created_todo = Todo:create(todo)

	if not created_todo then
		return nil,
			error_response(
				400,
				"Inavlid Request",
				"The request data is incomplete or incorrectly formatted. Please check the required fields."
			)
	end

	return created_todo
end

M.update_todo = function(id, patch)
	local existing_todo = Todo:find(id)

	if not existing_todo then
		return error_response(
			404,
			"Resource Not Found",
			"The requested Todo with ID " .. id .. " was not found in the system."
		)
	end

	local parsed_todo = from_json(to_json(existing_todo))
	json_patch.apply(parsed_todo, patch)

	if type(parsed_todo.is_completed) ~= "boolean" then
		return nil,
			error_response(
				422,
				"Unprocessable Entity",
				"The 'is_completed' field must be either true or false. Please provide a valid boolean value."
			)
	end

	local function patch_updated_todo()
		existing_todo:update(parsed_todo)
	end

	local is_update_success = pcall(patch_updated_todo)

	if not is_update_success then
		return nil,
			error_response(
				409,
				"Error While Patching Entity",
				"The update operation for Todo ID "
					.. id
					.. " caused a data conflict. Please check the provided values."
			)
	end

	return Todo:find(id)
end

return M
