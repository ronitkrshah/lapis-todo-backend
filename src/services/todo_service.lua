local Todo = require("src.models.Todo")
local utils = require("lapis.util")
local json_patch = require("lua-jsonpatch")

local from_json, to_json = utils.from_json, utils.to_json

local M = {}

M.get_all_todos = function()
	return Todo:select()
end

M.get_todo_by_id = function(id)
	return Todo:find(id)
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
	local err = json_patch.apply(parsed_todo, patch)

	if err then
		return nil
	end

	return existing_todo:update(parsed_todo)
end

return M
