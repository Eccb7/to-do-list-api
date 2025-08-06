class CreateTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.text :description
      t.boolean :completed, default: false
      t.integer :priority, default: 1
      t.integer :created_by, null: false

      t.timestamps
    end

    add_index :todos, :created_by
    add_index :todos, :completed
    add_index :todos, :priority
    add_foreign_key :todos, :users, column: :created_by
  end
end
