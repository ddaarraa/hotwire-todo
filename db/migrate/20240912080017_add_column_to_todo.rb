class AddColumnToTodo < ActiveRecord::Migration[7.2]
  def change
    add_column :todos, :duedate, :date
  end
end
