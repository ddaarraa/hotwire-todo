
class DueDateReminderJob < ApplicationJob
  queue_as :default

  def perform

    todos_due_today = Todo.all

    todos_due_today.each do |todo|
      user_id = todo.user_id
      user = User.find_by(user_id: user_id)

      UserMailer::due_date_reminder(user, todo).deliver_now if user.present?
    end
  end
end
