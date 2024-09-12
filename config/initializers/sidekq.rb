# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Daily due date reminder',
  cron: '0 0 * * *', # Runs daily at midnight
  class: 'DueDateReminderJob'
)
