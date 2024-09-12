class RemoveUserIdIndexFromTodos < ActiveRecord::Migration[7.2]
  def change
    remove_index :todos, :user_id
  end
end
