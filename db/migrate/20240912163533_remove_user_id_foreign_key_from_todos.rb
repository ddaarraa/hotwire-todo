class RemoveUserIdForeignKeyFromTodos < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :todos, column: :user_id
  end
end
