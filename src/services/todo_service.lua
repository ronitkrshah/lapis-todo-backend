local Todo = require("src.models.Todo")
local utils = require("lapis.util")
local yield_error = require("lapis.application").yield_error
local json_patch = require("lua-jsonpatch")

local from_json, to_json = utils.from_json, utils.to_json

local M = {}

M.get_all_todos = function()
	return Todo:select()
end

M.get_todo_by_id = function(id)
	local todo = Todo:find(id)

	if not todo then
		yield_error("Todo Not Found")
	end
	return todo
end

M.create_todo = function(todo)
	return Todo:create({
		id = Todo:count() + 1,
		todo = todo.todo,
		is_completed = todo.is_completed or 0,
	})
end

M.update_todo = function(id, patch)
	local existing_todo = Todo:find(id)

	if not existing_todo then
		return nil
	end

	local parsed_todo = from_json(to_json(existing_todo))
	json_patch.apply(parsed_todo, patch)

	if type(parsed_todo.is_completed) ~= "boolean" then
		yield_error("is_completed must be a boolean value")
	end

	local function patch_updated_todo()
		existing_todo:update(parsed_todo)
	end

	local v = pcall(patch_updated_todo)

	if not v then
		yield_error(
			"Your request contains an invalid operation, path, or format. Please ensure it follows the JSON Patch standard."
		)
	end

	return Todo:find(id)
end

return M
