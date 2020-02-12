class Report < ApplicationRecord
    validates :date ,uniqueness: true
    validates :no_of_profiles , presence: true
  
    def self.get_report(date)
        report = Report.find_by(date: date)
    end
end
