class ReportGeneratorWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :report_queue, :unique => :all
  def perform(*args)
    file_ptr = File.new('report.txt', 'w')
    data = User.report_generator
    file_ptr.write("\tDate\t\tCount\n");
    file_ptr.write("#{Date.today}")
    file_ptr.write("\t\t")
    file_ptr.write("#{data}")
    file_ptr.close
    
    puts "Report has been generated!"
  end
end

Sidekiq::Cron::Job.create(name: 'Generate Report EveryDay', cron: '* /40 *  *  * *', class: 'ReportGeneratorWorker')