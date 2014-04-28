# encoding: utf-8
class DiaoboshangsController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Diaoboshang, collection_name: 'diaoboshangs', instance_name: 'diaoboshang'
  # GET /diaoboshangs
  # GET /diaoboshangs.json
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
          @diaoboshangs = Diaoboshang.find(:all,:limit => limit, :offset =>start,:conditions => ["name like ? ","%" + params[:searchshangjia] +"%"] )
        elsif (params[:searchdizhi])
          @diaoboshangs = Diaoboshang.find(:all,:limit => limit, :offset =>start,:conditions => ["dizhi like ? ","%" + params[:searchdizhi] +"%"] )
        elsif (params[:searchleixing])
          @diaoboshangs = Diaoboshang.find(:all,:limit => limit, :offset =>start,:conditions => ["leixing like ? ","%" + params[:searchleixing] +"%"] ) 

        else
          @diaoboshangs = Diaoboshang.find(:all,:limit => limit, :offset =>start)
           dev_count = Diaoboshang.count
        end     
         griddata = Hash.new
         griddata[:diaoboshangs] =@diaoboshangs.collect{|d|
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
         griddata[:totalCount] = Diaoboshang.count
          
         render :text => griddata.to_json() 
        }
    end
  end

  # GET /diaoboshangs/1
  # GET /diaoboshangs/1.json
  def show
    @diaoboshang = Diaoboshang.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @diaoboshang }
    end
  end

  # GET /diaoboshangs/new
  # GET /diaoboshangs/new.json
  def new
    @diaoboshang = Diaoboshang.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @diaoboshang }
    end
  end

  # GET /diaoboshangs/1/edit
  def edit
    @diaoboshang = Diaoboshang.find(params[:id])
  end

  # POST /diaoboshangs
  # POST /diaoboshangs.json
  def create
    @diaoboshang = Diaoboshang.new(params[:diaoboshang])

    respond_to do |format|
      if @diaoboshang.save
        format.html { redirect_to @diaoboshang, notice: 'Diaoboshang was successfully created.' }
        format.js { 
          response.headers["Content-Type"] = "text/javascript; charset=utf-8"
          render :layout => false
           }
        format.json { render json: @diaoboshang, status: :created, location: @diaoboshang }
      else
        format.html { render action: "new" }
        format.json { render json: @diaoboshang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /diaoboshangs/1
  # PUT /diaoboshangs/1.json
  def update
    @diaoboshang = Diaoboshang.find(params[:id])

    respond_to do |format|
      if @diaoboshang.update_attributes(params[:diaoboshang])
        format.html { redirect_to @diaoboshang, notice: 'Diaoboshang was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @diaoboshang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diaoboshangs/1
  # DELETE /diaoboshangs/1.json
  def destroy
    @diaoboshang = Diaoboshang.find(params[:id])
    @diaoboshang.destroy

    respond_to do |format|
      format.html { redirect_to diaoboshangs_url }
      format.json { head :no_content }
    end
  end
end
