class ApiDocsController < ApplicationController
  def index
    docs = {
      api_name: "To-Do List API",
      version: "1.0.0",
      description: "RESTful API for managing to-do lists with user authentication",
      base_url: request.base_url,
      authentication: {
        type: "JWT Bearer Token",
        header: "Authorization: Bearer <token>"
      },
      endpoints: {
        authentication: {
          login: {
            method: "POST",
            path: "/auth/login",
            description: "Authenticate user and get JWT token",
            body: {
              email: "string (required)",
              password: "string (required)"
            }
          },
          signup: {
            method: "POST",
            path: "/signup",
            description: "Register new user account",
            body: {
              name: "string (required)",
              email: "string (required)",
              password: "string (required)",
              password_confirmation: "string (required)"
            }
          }
        },
        todos: {
          list: {
            method: "GET",
            path: "/todos",
            description: "Get all todos for authenticated user",
            query_params: {
              page: "integer (pagination)",
              status: "string (completed|pending)",
              sort_by: "string (priority)"
            }
          },
          create: {
            method: "POST", 
            path: "/todos",
            description: "Create a new todo",
            body: {
              title: "string (required)",
              description: "string (optional)",
              priority: "integer (optional, default: 1)"
            }
          },
          show: {
            method: "GET",
            path: "/todos/:id",
            description: "Get a specific todo"
          },
          update: {
            method: "PUT",
            path: "/todos/:id",
            description: "Update a todo",
            body: {
              title: "string (optional)",
              description: "string (optional)",
              completed: "boolean (optional)",
              priority: "integer (optional)"
            }
          },
          delete: {
            method: "DELETE",
            path: "/todos/:id",
            description: "Delete a todo"
          }
        }
      },
      status_codes: {
        "200": "OK - Request successful",
        "201": "Created - Resource created successfully",
        "204": "No Content - Resource deleted successfully",
        "400": "Bad Request - Invalid request format",
        "401": "Unauthorized - Authentication required",
        "404": "Not Found - Resource not found",
        "422": "Unprocessable Entity - Validation failed"
      }
    }

    json_response(docs)
  end
end
