local uuid = require("uuid")
local ApiController = require("src.utilities.ApiController")
local todo_service = require("src.services.todo.todo_service")
local success_response = require("src.helpers.success_response")
local user_authentication_middleware = require("src.middlewares.user_authentication_middleware")
local create_todo_validation = require("src.validations.todo.create_todo_validation")
local request_body_validation_middleware = require("src.middlewares.request_body_validation_middleware")

return function(app)
	local controller = ApiController:create({ route = "/todos" }, app)

	-- Get All Todos
	controller:http_get("", { user_authentication_middleware }, function(req)
		local todos = todo_service.get_all_todos(req.user.user_id)
		return success_response(todos)
	end)

	-- Get a single todo
	controller:http_get("/:id", { user_authentication_middleware }, function(req)
		local todo, err = todo_service.get_todo_by_id(req.user.id, req.params.id)

		if err then
			return err
		end
		return success_response(todo)
	end)

	-- Create A Todo
	controller:http_post(
		"/create",
		{ user_authentication_middleware, request_body_validation_middleware(create_todo_validation) },
		function(app, body)
			local current_time = os.time()

			local validated_todo = {
				id = uuid.v4(),
				title = body.title,
				description = body.description or "",
				status = "pending", -- Initial status
				user_id = app.user.user_id,
				completed_on = "", -- Initial completed
				created_at = current_time,
				updated_at = current_time,
			}

			local todo, err = todo_service.create_todo(validated_todo)

			if not todo then
				return err
			end
			return success_response(201, todo)
		end
	)

	-- Create A Todo
	controller:http_post("/update", { user_authentication_middleware }, function(_, body)
		local status, err = todo_service.update_todo(body.id, body.patch)

		if not status then
			return err
		end
		return success_response(200, status)
	end)
end
