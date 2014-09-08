class CompaniesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  require 'open-uri'

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    binding.pry
    @company.user = User.find_by(uid: company_params['uid'])
      if @company.save
        respond_to do |format|
          if @company.save

            format.json { render :json => {:status => 200, :text => "ok"} }

          else
            format.json { render json: @company.errors, status: :unprocessable_entity }
          end
        end
      end
  end

  def show
    company = Company.find(params[:id])
    keywords = company.keywords
    doc = Nokogiri::HTML(open(company.url))
    @list = []

    a_nodes = doc.css("a")
    kwords = []
    keywords.each do |k|
       kwords << k.downcase
       kwords << k.capitalize
    end
    kwords.each do |keyword|
      a_nodes.each do |node|
        if node.text.include?(keyword)
          @list << { node.text => node['href'] }
        end
      end
    end
    @list
  end


  def company_params
    params.permit(:url, {:keywords => []}, :uid, :user_id, :user_email, :name)
  end
end
