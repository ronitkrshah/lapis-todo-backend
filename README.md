# TODO CRUD Backend (Lua Lapis)

A simple TODO CRUD backend using Lua Lapis with JWT authentication.

## Features
- JWT Authentication (Access & Refresh Token)
- Create, Read, Update, Delete (CRUD) for TODOs

## Installation

### Prerequisites
- Lua 5.1
- Luarocks
- SQLite

### Steps
1. **Clone the Repository**
   ```sh
   git clone https://github.com/ronitkrshah/todo-app TodoApp
   cd TodoApp
   ```

2. **Install Dependencies**
   ```sh
   luarocks install --only-deps --tree lua_modules todoapp-dev-1.rockspec
   ```

3. **Setup Database**
   ```sh
   lua_modules/bin/lapis migrate
   ```

4. **Run the Server**
   ```sh
   lua_modules/bin/lapis server
   ```

## API Endpoints
- Base Api Endpoint `localhost:8080/api/v1`
- You must include the `Authorization` header with a valid Bearer token for all routes, except `/auth/login` and `/auth/register`.

### Authentication
- `POST /auth/register` - Register a new user
  - ##### Request Body
  ```json
  {
    "username": "test",
    "email": "test@mail.com",
    "password": "password"
  }
  ```
- `POST /auth/login` - Get new access and refresh tokens  
  - ##### Request Body
  ```json
  {
    "email": "test@mail.com",
    "password": "password"
  }
  ```

### TODO CRUD
- `GET /todos` - List all TODOs
- `GET /todos/:id` - Get a specific TODO
- `POST /todos/create` - Create a TODO
  - ##### Request Body
  ```json
  {
    "title": "Play BGMI Now",
    "description": "I'm optional :)"
  }
  ```
- `POST /todos/update` - Update a TODO
  - ##### Request Body - ( Check [Json Patch](https://jsonpatch.com/) for patches)
  ```json
  {
    "id": "todo_id",
    "patch": [
      { "op": "replace", "path": "/status", "value": "completed" },
      { "op": "replace", "path": "/description", "value": "I'm a new desc" },     
    ]
  }
  ```
- `DELETE /todo/:id` - Delete a TODO

## License
This project is open-source and available under the MIT License.

