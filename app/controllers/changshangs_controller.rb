# encoding: utf-8
class ChangshangsController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Changshang, collection_name: 'changshangs', instance_name: 'changshang'
  # GET /Changshangs
  # GET /Changshangs.json
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
          @changshangs = Changshang.find(:all,:limit => limit, :offset =>start,:conditions => ["name like ? ","%" + params[:searchshangjia] +"%"] )
        elsif (params[:searchdizhi])
          @changshangs = Changshang.find(:all,:limit => limit, :offset =>start,:conditions => ["dizhi like ? ","%" + params[:searchdizhi] +"%"] )
        elsif (params[:searchleixing])
          @changshangs = Changshang.find(:all,:limit => limit, :offset =>start,:conditions => ["leixing like ? ","%" + params[:searchleixing] +"%"] ) 

        else
          @changshangs = Changshang.find(:all,:limit => limit, :offset =>start)
           dev_count = Changshang.count
        end     
         griddata = Hash.new
         griddata[:changshangs] =@changshangs.collect{|d|
           sps = %{}
           d.shangpins.each do |sp|
             sps << sp.name.to_s + sp.guige.to_s + "X" + sp.danzhong.to_s + "KG" + "---"
           end
           
           shs = %{}
           d.shanghus.each do |sh|
             shs << sh.tanwei.tanweihao.to_s + sh.zihao + "---"
           end
 
           {:id => d.id,:name =>d.name,:dizhi => d.dizhi, :leixing => d.leixing, :zhizhao => d.zhizhao, :shengchanxuke => d.shengchanxuke,:yangzhi => d.yangzhi,:fangyi => d.fangyi,:zhonghes => sps + shs}
           }
         griddata[:totalCount] = Changshang.count
          
         render :text => griddata.to_json() 
        }
    end
  end

  # GET /Changshangs/1
  # GET /Changshangs/1.json
  def show
    @changshang = Changshang.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @Changshang }
    end
  end

  # GET /Changshangs/new
  # GET /Changshangs/new.json
  def new
    @changshang = Changshang.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @Changshang }
    end
  end

  # GET /Changshangs/1/edit
  def edit
    @changshang = Changshang.find(params[:id])
  end

  # POST /Changshangs
  # POST /Changshangs.json
  def create
    @changshang = Changshang.new(params[:changshang])

    respond_to do |format|
      if @changshang.save
        format.html { redirect_to @changshang, notice: 'Chang shang was successfully created.' }
        format.js { 
          response.headers["Content-Type"] = "text/javascript; charset=utf-8"
          render :layout => false
           }
        format.json { render json: @changshang, status: :created, location: @changshang }
      else
        format.html { render action: "new" }
        format.json { render json: @changshang.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /Changshangs/1
  # PUT /Changshangs/1.json
  def update
    @changshang = Changshang.find(params[:id])

    respond_to do |format|
      if @changshang.update_attributes(params[:changshang])
        format.html { redirect_to @changshang, notice: 'Chang shang was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @changshang.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Changshangs/1
  # DELETE /Changshangs/1.json
  def destroy
    @changshang = Changshang.find(params[:id])
    @changshang.destroy

    respond_to do |format|
      format.html { redirect_to changshangs_url }
      format.json { head :no_content }
    end
  end
end
