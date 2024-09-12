class AddUserToTodos < ActiveRecord::Migration[7.2]
  def change
    add_reference :todos, :user, foreign_key: true, null: true 
  end
end
