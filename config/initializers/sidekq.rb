# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq-cron'

Sidekiq::Cron::Job.create(
  name: 'Due date reminder every minute',
  cron: '* * * * *', # Runs every minute
  class: 'DueDateReminderJob'
)
