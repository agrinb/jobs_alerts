class CompaniesController < ApplicationController

  def new
    @company = Company.new
  end

  def create
    #@user = User.find(session[:user_id])
    @company = Company.new(company_params)
    @user = User.find_by(uid: company_params['uid'])
    binding.pry
    @company.uid = @user.uid
      if @company.save
        respond_to do |format|
          if @company.save
            #format.html { redirect_to new_company_path, notice: 'Company was successfully created.' }
            format.json { render :show, status: :created}
          else
            #format.html { render :new }
            format.json { render json: @company.errors, status: :unprocessable_entity }
          end
        end
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
