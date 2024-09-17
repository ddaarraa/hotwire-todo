class ToDoExpireJob < ApplicationJob
  queue_as :default

  def perform(todo)
    puts "Performing job for Todo: #{todo.inspect}"

    # Attempt to update the status

    if todo.status == 'incomplete'
      if (todo.duedate.to_i / 60) == (Time.current.to_i / 60)

        todo.update(status: 'expired')

        user = User.find_by(id: todo.user_id)
        UserMailer.job_expire_notifier(user, todo).deliver_now if user.present?
      end
    end

  end
end
