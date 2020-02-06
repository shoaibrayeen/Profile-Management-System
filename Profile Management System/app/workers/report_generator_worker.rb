class ReportGeneratorWorker
  
  include Sidekiq::Worker
  def perform(*args)
    date = Date.today.to_s
    if Report.where(date:date).first
      report = Report.where(date:date).first
      report.no_of_profiles = report.no_of_profiles + 1
      report.save
    else
      Report.create(:date => date, :no_of_profiles =>1)
    end
    puts "Inserted in Report Table"
  end
end
