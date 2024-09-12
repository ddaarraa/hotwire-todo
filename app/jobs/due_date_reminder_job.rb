
class DueDateReminderJob < ApplicationJob
  queue_as :default

  def perform
   
    todos_due_today = Todo.where(duedate: Date.today)

    todos_due_today.each do |todo|
      user = todo.user
      UserMailer.due_date_reminder(user, todo).deliver_now if user.present?
    end
  end
end
