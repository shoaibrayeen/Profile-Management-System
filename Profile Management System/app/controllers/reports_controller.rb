class ReportsController < ApplicationController
  before_action :authorized
  def index
  end

  def result
    if params[:date] == ""
      flash[:error] = 'Kindly Enter date'
      redirect_to reports_index_path
    else
      @report = Report.get_report(params[:date].to_s)
      if @report.nil?
        flash[:error] = "No Profile Created on the given Date - #{params[:date]}"
        redirect_to reports_index_path
      end
    end
  end
end
