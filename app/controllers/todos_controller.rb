class TodosController < ApplicationController
  include Authenticable

  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = current_user.todos.page(params[:page])
    
    # Filter by status if provided
    @todos = @todos.completed if params[:status] == 'completed'
    @todos = @todos.pending if params[:status] == 'pending'
    
    # Order by priority if requested
    @todos = @todos.by_priority if params[:sort_by] == 'priority'

    json_response(@todos)
  end

  # POST /todos
  def create
    @todo = current_user.todos.create!(todo_params)
    json_response(@todo, :created)
  end

  # GET /todos/:id
  def show
    json_response(@todo)
  end

  # PUT /todos/:id
  def update
    @todo.update!(todo_params)
    json_response(@todo)
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def todo_params
    params.permit(:title, :description, :completed, :priority)
  end

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end
end
