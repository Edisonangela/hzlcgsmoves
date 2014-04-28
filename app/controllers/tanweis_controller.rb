# encoding: utf-8
class TanweisController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Tanwei, collection_name: 'tanweis', instance_name: 'tanwei'
  # GET /tanweis
  # GET /tanweis.json
    #before_filter :authorize_quanxian
  #private
  def authorize_quanxian  
    if session[:user_power] == '工作员' or session[:user_power] == nil
      flash[:notice]="请先登陆"
      redirect_to(:controller =>"users", :action=>"login")
    end
  end
  
  def index
    limit = params[:limit] || 25
    start = params[:start] || 0

    respond_to do |format|
      format.html # index.html.erb
      format.json  { 
        if(params[:search])
          @tanweis = Tanwei.find(:all,:limit => limit, :offset =>start,:conditions => ["tanweihao like ? ","%" + params[:search] +"%"] )
          else
          @tanweis = Tanwei.find(:all,:limit => limit, :offset =>start)
          dev_count = Tanwei.count
          end     
         griddata = Hash.new
         griddata[:tanweis] =@tanweis.collect{|d|
           {:id => d.id, :tanweihao => d.tanweihao, :mianji => d.mianji}
           }
         griddata[:totalCount] = Tanwei.count
          
         render :text => griddata.to_json() 
        }
    end
  end

  # GET /tanweis/1
  # GET /tanweis/1.json
  def show
    @tanwei = Tanwei.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tanwei }
    end
  end

  # GET /tanweis/new
  # GET /tanweis/new.json
  def new
    @tanwei = Tanwei.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tanwei }
    end
  end

  # GET /tanweis/1/edit
  def edit
    @tanwei = Tanwei.find(params[:id])
  end

  # POST /tanweis
  # POST /tanweis.json
  def create
    @tanwei = Tanwei.new(params[:tanwei])

    respond_to do |format|
      if @tanwei.save
        format.html { redirect_to @tanwei, notice: 'Tanwei was successfully created.' }
        format.json { render json: @tanwei, status: :created, location: @tanwei }
      else
        format.html { render action: "new" }
        format.json { render json: @tanwei.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tanweis/1
  # PUT /tanweis/1.json
  def update
    @tanwei = Tanwei.find(params[:id])

    respond_to do |format|
      if @tanwei.update_attributes(params[:tanwei])
        format.html { redirect_to @tanwei, notice: 'Tanwei was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tanwei.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tanweis/1
  # DELETE /tanweis/1.json
  def destroy
    @tanwei = Tanwei.find(params[:id])
    @tanwei.destroy

    respond_to do |format|
      format.html { redirect_to tanweis_url }
      format.json { head :no_content }
    end
  end
  
  def associate
    @tanwei = Tanwei.find(params[:id])
    @tanwei.shanghu_ids = params[:shanghus]
    redirect_to tanwei_url(@tanwei)
  end
  
  def ajaxshanghu
    response.headers["Content-Type"] = "text/javascript; charset=utf-8"
    @tanwei = Tanwei.find_by_tanweihao(params[:id])
    @shanghus = @tanwei.shanghus
    respond_to do |format|
       format.js { render :layout => false }
    end
  end
end
