class CompaniesController < ApplicationController
  def new
    @company = Company.new
  end

  def create
    @user = User.find(session[:user_id])
    @company = Company.new(company_params)
    binding.pry
    @company.uid = @user.uid
    @company.user_id = @user.id
    if @company.save
      flash[:notice] = "Company created successfully."
      redirect_to new_company_path
    else
      flash[:alert] = "Company could not be saved."
      render :new
    end
  end


    # @property = Property.find(params[:property_id])
    # @appointment = Appointment.new(appointment_params)
    # @appointment.property = @property
    # ApptMailer.send_notify_agents(@appointment)
    # if @appointment.save
    #   flash[:notice] = "Appointment created successfully."
    #   redirect_to property_path(@property)
    # else
    #   flash[:alert] = "Appointment could not be saved."
    #   render :new
    # end


  def company_params
    params.require(:company).permit(:url, :keywords, :uid, :user_id)
  end

end
