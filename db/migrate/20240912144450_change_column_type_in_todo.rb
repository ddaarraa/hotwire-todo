class ChangeColumnTypeInTodo < ActiveRecord::Migration[7.2]
  def change
    change_column :todos, :duedate, :datetime
  end
end
