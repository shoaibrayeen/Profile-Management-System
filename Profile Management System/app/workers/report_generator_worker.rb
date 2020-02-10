class ReportGeneratorWorker
 
=begin
  **Author:** Mohd Shoaib Rayeen  
  **Common Name:** Worker to put information in the DB
=end

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
