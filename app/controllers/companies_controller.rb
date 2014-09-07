class CompaniesController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  require 'open-uri'

  def new
    @company = Company.new
  end

  def create
    #@user = User.find(session[:user_id])
    @company = Company.new(company_params)
    @company.user = User.find_by(uid: company_params['uid'])
    binding.pry
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














    # doc.traverse do |node|
    # next if node.is_a?(::Nokogiri::XML::Text)
    # binding.pry
    #   unless node.text == nil
    #     binding.pry
    #     @list << node if node.text.include?('Developer')
    #     binding.pry
    #       @list.map! do |a|
    #         if a.respond_to?(:children)
    #           a.children[0]
    #         end
    #       end
    #     @list
    #   end
    # end
  #   binding.pry
  #   ::Nokogiri::XML::NodeSet.new(doc, @list)
  # end


  def company_params
    params.permit(:url, {:keywords => []}, :uid, :user_id, :user_email)
  end
end
