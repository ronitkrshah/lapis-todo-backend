local ApiController = require("src.utilities.ApiController")
local todo_service = require("src.services.todo.todo_service")
local success_response = require("src.helpers.success_response")
local user_authentication_middleware = require("src.middlewares.user_authentication_middleware")

return function(app)
	local controller = ApiController:create({ route = "/todos" }, app)

	-- Get All Todos
	controller:http_get("", { user_authentication_middleware }, function(req)
		local todos = todo_service.get_all_todos(req.user.user_id)
		return success_response(todos)
	end)

	-- Get a single todo
	controller:http_get("/:id", {}, function(req)
		local todo, err = todo_service.get_todo_by_id(req.params.id)

		if err then
			return err
		end
		return success_response(todo)
	end)

	-- Create A Todo
	controller:http_post("/create", {}, function(_, body)
		local todo, err = todo_service.create_todo(body)

		if not todo then
			return err
		end

		return success_response(201, todo)
	end)

	-- Create A Todo
	controller:http_post("/update", {}, function(_, body)
		local status, err = todo_service.update_todo(body.id, body.patch)

		if not status then
			return err
		end
		return success_response(200, status)
	end)
end
