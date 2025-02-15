local ApiController = require("src.utilities.ApiController")
local todo_service = require("src.services.todo_service")

return function(app)
	local controller = ApiController:create({ route = "todos" }, app)

	-- Get All Todos
	controller:http_get(function(req)
		return { json = todo_service.get_all_todos() }
	end)

	-- Get a single todo
	controller:http_get(":id", function(req)
		local todo = todo_service.get_todo_by_id(req.params.id)

		if not todo then
			return { status = 404, json = { status = "failure", success = false, message = "Todo Not Found!" } }
		end
		return { json = todo }
	end)

	-- Create A Todo
	controller:http_post("create", function(_, body)
		local todo = todo_service.create_todo(body)
		return { json = {
			status = "success",
			data = todo,
		} }
	end)

	-- Create A Todo
	controller:http_post("update", function(_, body)
		local status = todo_service.update_todo(body.id, body.patch)
		return { json = { success = status } }
	end)
end
