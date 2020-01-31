class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    #puts "Hye"
    #user = User.group(:created_at).count
    #users = User.where(created_at: Date.today.all_day ).count
    # Do something later
  end
end
