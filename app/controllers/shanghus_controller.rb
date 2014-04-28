class ShanghusController < BaseController
  #main_nav_highlight :users
  defaults resource_class: Shanghu, collection_name: 'shanghus', instance_name: 'shanghu'
  # GET /shanghus
  # GET /shanghus.json
  #respond_to :js, :only => :search
#  def index
#    limit = params[:limit] || 25
#    start = params[:start] || 0#

#    respond_to do |format|
#      format.html # index.html.erb
#      format.json  { 
#       if(params[:searchtanweihao])
#          @tanweis = Tanwei.find(:all,:limit => limit, :offset =>start,:conditions => ["tanweihao like ? ","%" + params[:searchtanweihao] +"%"] )
#          @shanghus = Array.new
#          @tanweis.each do |tw|
#            tw.shanghus.each do |sh|
#            
#              @shanghus << sh 
#            end
#          end
#         
#        elsif (params[:searchzihao])
#          @shanghus = Shanghu.find(:all,:limit => limit, :offset =>start,:conditions => ["zihao like ? ","%" + params[:searchzihao] +"%"] )
#        elsif (params[:searchfuzeren])
#          @shanghus = Shanghu.find(:all,:limit => limit, :offset =>start,:conditions => ["fuzeren like ? ","%" + params[:searchfuzeren] +"%"] ) #

#           
#           
#            else
#          @shanghus = Shanghu.find(:all,:limit => limit, :offset =>start)
#           dev_count = Shanghu.count
#          end     
#         griddata = Hash.new
#         griddata[:shanghus] =@shanghus.collect{|d|
#         
#           tanweihao = d.tanwei.tanweihao if d.tanwei != nil
#           {:id => d.id, :tanweihao => tanweihao, :zihao => d.zihao, :fuzeren => d.fuzeren, :dianhua => d.dianhua, :leixing => d.leixing}
#           }
#         griddata[:totalCount] = Shanghu.count
#          
#         render :text => griddata.to_json() 
#        }
#    end
#  end#

#  # GET /shanghus/1
#  # GET /shanghus/1.json
#  def show
#    @shanghu = Shanghu.find(params[:id])#

#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @shanghu }
#    end
#  end#

#  # GET /shanghus/new
#  # GET /shanghus/new.json
#  def new
#    @shanghu = Shanghu.new#

#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @shanghu }
#    end
#  end#

#  # GET /shanghus/1/edit
#  def edit
#    @shanghu = Shanghu.find(params[:id])
#  end#

#  # POST /shanghus
#  # POST /shanghus.json
#  def create
#    @shanghu = Shanghu.new(params[:shanghu])#

#    respond_to do |format|
#      if @shanghu.save
#        format.html { redirect_to @shanghu, notice: 'Shang hu was successfully created.' }
#        format.json { render json: @shanghu, status: :created, location: @shanghu }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @shanghu.errors, status: :unprocessable_entity }
#      end
#    end
#  end#

#  # PUT /shanghus/1
#  # PUT /shanghus/1.json
#  def update
#    @shanghu = Shanghu.find(params[:id])#

#    respond_to do |format|
#      if @shanghu.update_attributes(params[:shanghu])
#        format.html { redirect_to @shanghu, notice: 'Shang hu was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @shanghu.errors, status: :unprocessable_entity }
#      end
#    end
#  end#

#  # DELETE /shanghus/1
#  # DELETE /shanghus/1.json
#  def destroy
#    @shanghu = Shanghu.find(params[:id])
#    @shanghu.destroy#

#    respond_to do |format|
#      format.html { redirect_to shanghus_url }
#      format.json { head :no_content }
#    end
#  end
#  
#  def search
#    response.headers["Content-Type"] = "text/javascript; charset=utf-8"
#    @results = Shanghu.find(:all, :conditions => ["fuzeren like ?", "%" + params[:shuju] + "%"])
#      respond_to do |format|
#    if @results != nil#

#      format.js { render :layout => false }
#    else
#      format.html { render :new }
#      format.js { render :layout => false, :status => 406  }
#    end
#    end
#  end


  def beianchaxun
    @shanghu = Shanghu.new
  end
  
#shipinanquan模块，分别建立商户与  厂商/供应商/调拨商/小作坊之间的关系
  def associate_shangjia
     
    @shanghu = Shanghu.find(params[:id])
    @shanghu.gongyingshang_ids = params[:gongyingshangs]
    @shanghu.changshang_ids = params[:changshangs]
    @shanghu.diaoboshang_ids = params[:diaoboshangs]
    @shanghu.xiaozuofang_ids = params[:xiaozuofangs]
    redirect_to "/shipinanquan/sj/#{params[:id]}"
  
  end
#shipinanquan模块，分别建立食品   与商户和厂家的关联 
  def associate_changshangsp
    @shanghu = Shanghu.find(params[:id])
    @shangjia = Changshang.find(params[:shangjia_id])
    guanxi(params[:laoshangpin_id],params[:shangpins])
   

    redirect_to  :controller => "shipinanquan",:action => "changshangsp",:shanghu_id => @shanghu.id,:shangjia_id => @shangjia.id 
  end
#shipinanquan模块，分别建立食品   与商户和供应商的关联 
  def associate_gongyingshangsp

    @shanghu = Shanghu.find(params[:id])
    @shangjia = Gongyingshang.find(params[:shangjia_id])
    guanxi(params[:laoshangpin_id],params[:shangpins])
    redirect_to  :controller => "shipinanquan",:action => "gongyingshangsp",:shanghu_id => @shanghu.id,:shangjia_id => @shangjia.id 
  end
#shipinanquan模块，分别建立食品   与商户和调拨商的关联 
  def associate_diaoboshangsp
    @shanghu = Shanghu.find(params[:id])
    @shangjia = Diaoboshang.find(params[:shangjia_id])
    guanxi(params[:laoshangpin_id],params[:shangpins])
    redirect_to  :controller => "shipinanquan",:action => "diaoboshangsp",:shanghu_id => @shanghu.id,:shangjia_id => @shangjia.id 
  end
#shipinanquan模块，分别建立食品   与商户和小作坊的关联 
  def associate_xiaozuofangsp
    @shanghu = Shanghu.find(params[:id])
    @shangjia = Xiaozuofang.find(params[:shangjia_id])
    guanxi(params[:laoshangpin_id],params[:shangpins])
    redirect_to  :controller => "shipinanquan",:action => "xiaozuofangsp",:shanghu_id => @shanghu.id,:shangjia_id => @shangjia.id 
  end
  
  def guanxi (lao,xin)
   
    if lao == nil
      lao = %w{}
    end
    if xin == nil
      xin = %w{}
    end
    
    @zeng = xin - lao
    @shan = lao - xin
   
     @zeng.each do |f|
      @newsp = Shangpin.find(f)
      @shanghu.shangpins << @newsp
      @shangjia.shangpins << @newsp
     end  
     @shan.each do |s|
      @shansp = Shangpin.find(s)
      @shanghu.shangpins.delete(@shansp)
     end
  end


end
