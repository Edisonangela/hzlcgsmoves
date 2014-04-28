# encoding: utf-8
class XiaozuofangsController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Xiaozuofang, collection_name: 'xiaozuofangs', instance_name: 'xiaozuofang'
  # GET /xiaozuofangs
  # GET /xiaozuofangs.json
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
        if(params[:searchshangjia])
          @xiaozuofangs = Xiaozuofang.find(:all,:limit => limit, :offset =>start,:conditions => ["name like ? ","%" + params[:searchshangjia] +"%"] )
        elsif (params[:searchdizhi])
          @xiaozuofangs = Xiaozuofang.find(:all,:limit => limit, :offset =>start,:conditions => ["dizhi like ? ","%" + params[:searchdizhi] +"%"] )
        elsif (params[:searchleixing])
          @xiaozuofangs = Xiaozuofang.find(:all,:limit => limit, :offset =>start,:conditions => ["leixing like ? ","%" + params[:searchleixing] +"%"] ) 

        else
          @xiaozuofangs = Xiaozuofang.find(:all,:limit => limit, :offset =>start)
           dev_count = Xiaozuofang.count
        end     
         griddata = Hash.new
         griddata[:xiaozuofangs] =@xiaozuofangs.collect{|d|
           sps = %{}
           d.shangpins.each do |sp|
             sps << sp.name.to_s + sp.guige.to_s + "X" + sp.danzhong.to_s + "KG" + "---"
           end
           
           shs = %{}
           d.shanghus.each do |sh|
             shs << sh.tanwei.tanweihao.to_s + sh.zihao + "---"
           end
 
           {:id => d.id,:name =>d.name,:dizhi => d.dizhi, :leixing => d.leixing, :lianxidianhua => d.lianxidianhua,:zhonghes => sps + shs}
           }
         griddata[:totalCount] = Xiaozuofang.count
          
         render :text => griddata.to_json() 
        }
    end
  end

  # GET /xiaozuofangs/1
  # GET /xiaozuofangs/1.json
  def show
    @xiaozuofang = Xiaozuofang.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @xiaozuofang }
    end
  end

  # GET /xiaozuofangs/new
  # GET /xiaozuofangs/new.json
  def new
    @xiaozuofang = Xiaozuofang.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @xiaozuofang }
    end
  end

  # GET /xiaozuofangs/1/edit
  def edit
    @xiaozuofang = Xiaozuofang.find(params[:id])
  end

  # POST /xiaozuofangs
  # POST /xiaozuofangs.json
  def create
    @xiaozuofang = Xiaozuofang.new(params[:xiaozuofang])

    respond_to do |format|
      if @xiaozuofang.save
        format.html { redirect_to @xiaozuofang, notice: 'Xiaozuofang was successfully created.' }
        format.js { 
          response.headers["Content-Type"] = "text/javascript; charset=utf-8"
          render :layout => false
           }
        format.json { render json: @xiaozuofang, status: :created, location: @xiaozuofang }
      else
        format.html { render action: "new" }
        format.json { render json: @xiaozuofang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /xiaozuofangs/1
  # PUT /xiaozuofangs/1.json
  def update
    @xiaozuofang = Xiaozuofang.find(params[:id])

    respond_to do |format|
      if @xiaozuofang.update_attributes(params[:xiaozuofang])
        format.html { redirect_to @xiaozuofang, notice: 'Xiaozuofang was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @xiaozuofang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /xiaozuofangs/1
  # DELETE /xiaozuofangs/1.json
  def destroy
    @xiaozuofang = Xiaozuofang.find(params[:id])
    @xiaozuofang.destroy

    respond_to do |format|
      format.html { redirect_to xiaozuofangs_url }
      format.json { head :no_content }
    end
  end
end
