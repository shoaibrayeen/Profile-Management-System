class AdminsController < ApplicationController
  include AdminsHelper
  def index
    #redirect_to '/users' and return
    #render 'users/index'
    #puts "Working"
    
  end
  
  def search
    user = User.last
    Rails.cache.write(user.id,user)
    data = Rails.cache.read(user.id)
    puts "This is #{data.name} with #{user.id}"

  end

  def search_result
    #byebug
    
    field = params[:field]
    query = params[:query] 
=begin
    if query == ""
      flash[:error] = "Email Can't be Empty"
      redirect_to admins_search_path
    end
=end
    @adminObj = User.search_record(params)
    if !@adminObj.first
      flash[:Error] = "Either Query is empty or Record Not Found!"
      redirect_to admins_search_path
    end
    '
    #@adminObj = User.find_by( "#{field}" => "#{query}") 
    
    #render plain: @admin
    '
    
    #@adminObj = getData.first
    #render plain: "hye, this is search result"
  end

  def report
    ReportGenratorWorker.perform_async
    #render plain: @adminObj 
  end

  def view
    @adminObj = getData
  end
  
  def new
    @adminObj = User.new
  end

  def create
    @adminObj = User.new(user_params)
    if @adminObj.save
        redirect_to admins_view_path
        return
    end
    render 'new'
  end

  def show
    @adminObj = User.find_by(id: params[:id])
    if @adminObj == nil
        render plain: "Record Not Found"
    end
  end

  def update
    @adminObj = User.find(params[:id])
    if @adminObj.update(user_params)
        redirect_to @admin
    else
        render 'edit'
    end
  end

  def edit
    show
  end

  def destroy
    @adminObj = User.find(params[:id])
    @adminObj.destroy
 
    redirect_to admins_view_path
  end

end
