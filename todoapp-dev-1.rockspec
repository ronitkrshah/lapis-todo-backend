package = "TodoApp"
version = "dev-1"
source = {
   url = "https://github.com/ronitkrshah/todo-app.git"
}
description = {
   license = "MIT"
}
dependencies = {
   "lua ~> 5.1",
   "lapis >= 1.16.0-1",
   "lsqlite3",
   "lua-jsonpatch >= 0-10",
   "lua-resty-jwt >= 0.2.3-0",
   "lua-resty-jit-uuid >= 0.0.7-2",
   "bcrypt",
}
build = {
   type = "builtin",
   modules = {}
}
