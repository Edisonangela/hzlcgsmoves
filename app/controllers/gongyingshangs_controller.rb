# encoding: utf-8
class GongyingshangsController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Gongyingshang, collection_name: 'gongyingshangs', instance_name: 'gongyingshang'
  # GET /gongyingshangs
  # GET /gongyingshangs.json
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
          @gongyingshangs = Gongyingshang.find(:all,:limit => limit, :offset =>start,:conditions => ["name like ? ","%" + params[:searchshangjia] +"%"] )
        elsif (params[:searchdizhi])
          @gongyingshangs = Gongyingshang.find(:all,:limit => limit, :offset =>start,:conditions => ["dizhi like ? ","%" + params[:searchdizhi] +"%"] )
        elsif (params[:searchleixing])
          @gongyingshangs = Gongyingshang.find(:all,:limit => limit, :offset =>start,:conditions => ["leixing like ? ","%" + params[:searchleixing] +"%"] ) 

        else
          @gongyingshangs = Gongyingshang.find(:all,:limit => limit, :offset =>start)
           dev_count = Gongyingshang.count
        end     
         griddata = Hash.new
         griddata[:gongyingshangs] =@gongyingshangs.collect{|d|
           sps = %{}
           d.shangpins.each do |sp|
             sps << sp.name.to_s + sp.guige.to_s + "X" + sp.danzhong.to_s + "KG" + "---"
           end
           
           shs = %{}
           d.shanghus.each do |sh|
             shs << sh.tanwei.tanweihao.to_s + sh.zihao + "---"
           end
 
           {:id => d.id,:name =>d.name,:dizhi => d.dizhi, :leixing => d.leixing, :zhizhao => d.zhizhao, :liutong => d.liutong,:zhonghes => sps + shs}
           }
         griddata[:totalCount] = Gongyingshang.count
          
         render :text => griddata.to_json() 
        }
    end
  end

  # GET /gongyingshangs/1
  # GET /gongyingshangs/1.json
  def show
    @gongyingshang = Gongyingshang.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gongyingshang }
    end
  end

  # GET /gongyingshangs/new
  # GET /gongyingshangs/new.json
  def new
    @gongyingshang = Gongyingshang.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gongyingshang }
    end
  end

  # GET /gongyingshangs/1/edit
  def edit
    @gongyingshang = Gongyingshang.find(params[:id])
  end

  # POST /gongyingshangs
  # POST /gongyingshangs.json
  def create
    @gongyingshang = Gongyingshang.new(params[:gongyingshang])

    respond_to do |format|
      if @gongyingshang.save
        format.html { redirect_to @gongyingshang, notice: 'Gongyingshang was successfully created.' }
        format.js { 
          response.headers["Content-Type"] = "text/javascript; charset=utf-8"
          render :layout => false
           }
        format.json { render json: @gongyingshang, status: :created, location: @gongyingshang }
      else
        format.html { render action: "new" }
        format.json { render json: @gongyingshang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /gongyingshangs/1
  # PUT /gongyingshangs/1.json
  def update
    @gongyingshang = Gongyingshang.find(params[:id])

    respond_to do |format|
      if @gongyingshang.update_attributes(params[:gongyingshang])
        format.html { redirect_to @gongyingshang, notice: 'Gongyingshang was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gongyingshang.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #editgrid更新，route里有 get定义
  def updatel
    
    @gongyingshang = Gongyingshang.find(params[:id])
    @gongyingshang.try("#{params[:field]}=",params[:value])
    @gongyingshang.save
    respond_to do |format|
       format.json { head :no_content }
    end
  end
  
  #editgrid
  def deletel
    @gongyingshang = Gongyingshang.find(params[:id])
    @gongyingshang.destroy
    respond_to do |format|
       format.json { head :no_content }
    end
  end
  
  #editgrid
  def createl
    @gongyingshang = Gongyingshang.new()
    @gongyingshang.name = params[:name]

    respond_to do |format|
      if @gongyingshang.save
        #format.html { redirect_to @gongyingshang, notice: 'Gongyingshang was successfully created.' }
        #format.js { 
          #response.headers["Content-Type"] = "text/javascript; charset=utf-8"
         # render :layout => false
          # }
        format.json { 
          griddata = Hash.new
          griddata[:insert_id] = @gongyingshang.id
          render :text => griddata.to_json() }
      else
        format.html { render action: "new" }
        format.json { render json: @gongyingshang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gongyingshangs/1
  # DELETE /gongyingshangs/1.json
  def destroy
    @gongyingshang = Gongyingshang.find(params[:id])
    @gongyingshang.destroy

    respond_to do |format|
      format.html { redirect_to gongyingshangs_url }
      format.json { head :no_content }
    end
  end
  
  def sy
    
  end
  

end
