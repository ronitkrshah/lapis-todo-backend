local todo_controller = require("src.controllers.todo_controller")
local auth_controller = require("src.controllers.auth_controller")

return function(app)
	auth_controller(app)
	todo_controller(app)
end
