local todo_controller = require("src.controllers.todo_controller")

return function(app)
	todo_controller(app)
end
