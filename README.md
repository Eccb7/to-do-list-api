# To-Do List API

A RESTful API for managing to-do lists with user authentication built with Ruby on Rails.

## Features

- ✅ User registration and authentication
- ✅ JWT token-based authentication
- ✅ Full CRUD operations for todos
- ✅ User authorization (users can only manage their own todos)
- ✅ Task filtering by status (completed/pending)
- ✅ Task prioritization
- ✅ Pagination support
- ✅ PostgreSQL database
- ✅ CORS support
- ✅ Input validation and error handling

## Tech Stack

- **Backend**: Ruby on Rails 8.0 (API mode)
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens) with bcrypt
- **Pagination**: Kaminari
- **Testing**: Rails default test suite

## Prerequisites

- Ruby 3.3.0+
- PostgreSQL
- Bundler

## Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd to-do-list-api
```

2. Install dependencies:
```bash
bundle install
```

3. Setup the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the server:
```bash
rails server
```

The API will be available at `http://localhost:3000`

## API Documentation

### Base URL
```
http://localhost:3000
```

### Authentication

This API uses JWT tokens for authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

### Endpoints

#### Authentication

##### Register a new user
```http
POST /signup
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Response (201 Created):**
```json
{
  "message": "Account created successfully",
  "auth_token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

##### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "auth_token": "eyJhbGciOiJIUzI1NiJ9..."
}
```

#### Todos

All todo endpoints require authentication.

##### Get all todos
```http
GET /todos
Authorization: Bearer <your_jwt_token>
```

**Query Parameters:**
- `page` (optional): Page number for pagination
- `status` (optional): Filter by status (`completed` or `pending`)
- `sort_by` (optional): Sort by `priority`

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "title": "Complete Rails API tutorial",
    "description": "Build a comprehensive to-do list API with authentication",
    "completed": false,
    "priority": 1,
    "created_by": 1,
    "created_at": "2025-01-15T10:30:00Z",
    "updated_at": "2025-01-15T10:30:00Z"
  }
]
```

##### Create a new todo
```http
POST /todos
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "title": "New task",
  "description": "Task description",
  "priority": 1
}
```

**Response (201 Created):**
```json
{
  "id": 2,
  "title": "New task",
  "description": "Task description",
  "completed": false,
  "priority": 1,
  "created_by": 1,
  "created_at": "2025-01-15T11:00:00Z",
  "updated_at": "2025-01-15T11:00:00Z"
}
```

##### Get a specific todo
```http
GET /todos/:id
Authorization: Bearer <your_jwt_token>
```

##### Update a todo
```http
PUT /todos/:id
Authorization: Bearer <your_jwt_token>
Content-Type: application/json

{
  "title": "Updated task",
  "completed": true,
  "priority": 2
}
```

##### Delete a todo
```http
DELETE /todos/:id
Authorization: Bearer <your_jwt_token>
```

**Response (204 No Content)**

### Error Responses

The API returns standardized error responses:

**400 Bad Request:**
```json
{
  "message": "Validation failed: Email can't be blank"
}
```

**401 Unauthorized:**
```json
{
  "message": "Invalid token"
}
```

**404 Not Found:**
```json
{
  "message": "Sorry, Todo not found."
}
```

**422 Unprocessable Entity:**
```json
{
  "message": "Invalid credentials"
}
```

## Testing the API

### Using curl

1. Register a new user:
```bash
curl -X POST http://localhost:3000/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"password123","password_confirmation":"password123"}'
```

2. Login to get a token:
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

3. Create a todo (replace TOKEN with the actual token):
```bash
curl -X POST http://localhost:3000/todos \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer TOKEN" \
  -d '{"title":"My first todo","description":"Testing the API","priority":1}'
```

4. Get all todos:
```bash
curl -X GET http://localhost:3000/todos \
  -H "Authorization: Bearer TOKEN"
```

### Using the seed data

The application includes seed data with two users:

- **User 1**: john@example.com / password123
- **User 2**: jane@example.com / password123

## Project Structure

```
app/
├── controllers/
│   ├── application_controller.rb      # Base controller with common functionality
│   ├── authentication_controller.rb   # Handles login
│   ├── todos_controller.rb            # CRUD operations for todos
│   ├── users_controller.rb            # User registration
│   └── concerns/
│       ├── authenticable.rb           # JWT authentication logic
│       ├── exception_handler.rb       # Global error handling
│       └── response.rb                # JSON response helpers
├── models/
│   ├── user.rb                        # User model with authentication
│   └── todo.rb                        # Todo model with associations
├── services/
│   ├── authenticate_user.rb           # Login service
│   └── authorize_api_request.rb       # Token validation service
└── lib/
    ├── json_web_token.rb              # JWT encode/decode utilities
    └── message.rb                     # Standardized error messages
```

## Security Features

- **Password Encryption**: Using bcrypt with Rails' `has_secure_password`
- **JWT Authentication**: Secure token-based authentication
- **Authorization**: Users can only access their own todos
- **Input Validation**: Comprehensive model validations
- **SQL Injection Protection**: Using Rails' built-in protections
- **CORS Configuration**: Properly configured for API access

## Future Enhancements

- [ ] Password reset functionality
- [ ] Email verification
- [ ] API rate limiting
- [ ] Task categories/tags
- [ ] Task due dates and reminders
- [ ] File attachments for todos
- [ ] Team collaboration features
- [ ] API versioning
- [ ] Comprehensive test suite
- [ ] API documentation with Swagger/OpenAPI

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
