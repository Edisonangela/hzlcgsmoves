# encoding: utf-8
class ShangpinsController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Shangpin, collection_name: 'shangpins', instance_name: 'shangpin'
  # GET /shangpins
  # GET /shangpins.json
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
        if(params[:searchpinming])
          @shangpins = Shangpin.find(:all,:limit => limit, :offset =>start,:conditions => ["name like ? ","%" + params[:searchpinming] +"%"] )
        elsif (params[:searchpinlei])
          @shangpins = Shangpin.find(:all,:limit => limit, :offset =>start,:conditions => ["leixing like ? ","%" + params[:searchpinlei] +"%"] )
        elsif (params[:searchshangjia])
           @shangjias = Shangjia.find(:all,:limit => limit, :offset =>start,:conditions => ["name like ? ","%" + params[:searchshangjia] +"%"] ) 
           @shangpins = Array.new
           @shangjias.each do |sj|
              sj.shangpins.each do |sp|
                @shangpins << sp
              end
           end      
      
        elsif (params[:searchpinlei])
          @shangpins = Shangpin.find(:all,:limit => limit, :offset =>start,:conditions => ["leixing like ? ","%" + params[:searchpinlei] +"%"] ) 
        else
          @shangpins = Shangpin.find(:all,:limit => limit, :offset =>start)
           dev_count = Shangpin.count
        end     
         griddata = Hash.new
         griddata[:shangpins] = @shangpins.collect{|d|
           if d.changshang != nil
              shangjialeixing = '厂家'
              shangjia = d.changshang.name
           
           elsif d.diaoboshang != nil
              shangjialeixing = '调拨商'
              shangjia = d.diaoboshang.name
           
           elsif d.gongyingshang != nil
              shangjialeixing = '供应商'
              shangjia = d.gongyingshang.name
           
           elsif d.xiaozuofang != nil
              shangjialeixing = '小作坊'
              shangjia = d.xiaozuofang.name
           else
             
           end
           
           shs = %{}
           d.shanghus.each do |sh|
             shs << sh.tanwei.tanweihao.to_s + sh.zihao + "---"
           end
         {:id => d.id,:name =>d.name,:baozhuang => d.baozhuang, :guige => d.guige, :danzhong => d.danzhong, :leixing => d.leixing,:shangjia => shangjia,:shangjialeixing => shangjialeixing,:shanghus => shs}
           }
         griddata[:totalCount] = Shangpin.count
          
         render :text => griddata.to_json() 
        }
    end
  end

  # GET /shangpins/1
  # GET /shangpins/1.json
  def show
    @shangpin = Shangpin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shangpin }
    end
  end

  # GET /shangpins/new
  # GET /shangpins/new.json
  def new
    @shangpin = Shangpin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shangpin }
    end
  end

  # GET /shangpins/1/edit
  def edit
    @shangpin = Shangpin.find(params[:id])
  end

  # POST /shangpins
  # POST /shangpins.json
  def create
    @shangpin = Shangpin.new(params[:shangpin])

    respond_to do |format|
      if @shangpin.save
        format.html { redirect_to @shangpin, notice: 'Shangpin was successfully created.' }
        format.js { 
          response.headers["Content-Type"] = "text/javascript; charset=utf-8"
          render :layout => false
           }
        format.json { render json: @shangpin, status: :created, location: @shangpin }
      else
        format.html { render action: "new" }
        format.json { render json: @shangpin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shangpins/1
  # PUT /shangpins/1.json
  def update
    @shangpin = Shangpin.find(params[:id])

    respond_to do |format|
      if @shangpin.update_attributes(params[:shangpin])
        format.html { redirect_to @shangpin, notice: 'Shangpin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shangpin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shangpins/1
  # DELETE /shangpins/1.json
  def destroy
    @shangpin = Shangpin.find(params[:id])
    @shangpin.destroy

    respond_to do |format|
      format.html { redirect_to shangpins_url }
      format.json { head :no_content }
    end
  end

end
