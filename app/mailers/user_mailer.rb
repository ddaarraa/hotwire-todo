class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def due_date_reminder(user, todo)
    @user = user
    @todo = todo
    mail(to: @user.email, subject: 'Reminder: Your todo is due soon!')
  end
end
