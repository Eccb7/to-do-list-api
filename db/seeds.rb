# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create sample users
user1 = User.find_or_create_by!(email: "john@example.com") do |user|
  user.name = "John Doe"
  user.password = "password123"
  user.password_confirmation = "password123"
end

user2 = User.find_or_create_by!(email: "jane@example.com") do |user|
  user.name = "Jane Smith"
  user.password = "password123"
  user.password_confirmation = "password123"
end

puts "Created #{User.count} users"

# Create sample todos for user1 (only if they don't exist)
if user1.todos.empty?
  user1.todos.create!([
    {
      title: "Complete Rails API tutorial",
      description: "Build a comprehensive to-do list API with authentication",
      completed: false,
      priority: 1
    },
    {
      title: "Write API documentation",
      description: "Document all the endpoints and authentication flow",
      completed: false,
      priority: 2
    },
    {
      title: "Set up CI/CD pipeline",
      description: "Configure automated testing and deployment",
      completed: true,
      priority: 3
    }
  ])
end

# Create sample todos for user2 (only if they don't exist)
if user2.todos.empty?
  user2.todos.create!([
    {
      title: "Review code changes",
      description: "Review pull requests from team members",
      completed: false,
      priority: 1
    },
    {
      title: "Update project README",
      description: "Add setup instructions and API documentation",
      completed: false,
      priority: 2
    }
  ])
end

puts "Created #{Todo.count} todos"
puts "Seed data created successfully!"
