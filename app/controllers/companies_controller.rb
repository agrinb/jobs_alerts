class CompaniesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  require 'open-uri'

  def new
    @company = Company.new
  end

  def create
    #@user = User.find(session[:user_id])
    @company = Company.new(company_params)
    @user = User.find_by(uid: company_params['uid'])
      if @company.save
        respond_to do |format|
          if @company.save

            format.json { render :json => {:status => 200, :text => "ok"} }

            #format.html { redirect_to new_company_path, notice: 'Company was successfully created.' }
            #format.json { render :show, status: :created}
            #format.json { render json: @company }
          else
            #format.html { render :new }
            format.json { render json: @company.errors, status: :unprocessable_entity }
          end
        end
      end
  end

  def show
    company = Company.find(params[:id])
    doc = Nokogiri::HTML(open(company.url))
    @list = []
    doc.traverse do |node|
    next if node.is_a?(::Nokogiri::XML::Text)
      unless node.text == nil
        @list << node if node.text.include?('Developer')
          @list.map! do |a|
            if a.respond_to?(:children)
              a.children[0]
            end
          end
        @list
      end
    end
    binding.pry
    ::Nokogiri::XML::NodeSet.new(doc, @list)
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
    params.permit(:url, {:keywords => []}, :uid, :user_id, :user_email)
  end
end
