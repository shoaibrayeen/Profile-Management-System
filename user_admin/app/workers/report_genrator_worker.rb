class ReportGenratorWorker
  include Sidekiq::Worker

  def perform(*args)
    f = File.new('report.txt', 'w')
    data = User.where(created_at: Date.today.all_day ).count
    f.write("\tDate\t\tCount\n");
    f.write("#{Date.today}")
    f.write("\t\t")
    f.write("#{data}")
    f.close
    puts "Your Job is Done"

    # Do something
  end
end

#Sidekiq::Cron::Job.create(name: 'UserWorker-every 24 hours', cron: ' /1 * * * *', class: 'ReportGenratorWorker' )