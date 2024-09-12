class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def due_date_reminder(user, todo)
    @todo = todo
    @user = user
    mail(to: @user.email, subject: 'Reminder: Your todo is due soon!')
  end
end
