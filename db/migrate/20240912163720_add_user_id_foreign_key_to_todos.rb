class AddUserIdForeignKeyToTodos < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :todos, :users, column: :user_id
  end
end
