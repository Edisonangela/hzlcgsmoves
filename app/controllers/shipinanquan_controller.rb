# encoding: utf-8
class ShipinanquanController < BaseController
  #main_nav_highlight :user
  #defaults resource_class: User, collection_name: 'users', instance_name: 'user'
  def sjs
    @tanweis= Tanwei.find(:all, :conditions => ["tanweihao like ?", "%" + params[:shanghu][:tanweihao] + "%"])

    @shanghus = Array.new
    @tanweis.each do |tw|
      @shanghus<<tw.shanghus.first
    end
  end

  def sj
    @tanwei = Tanwei.find_by_tanweihao(params[:tanweihao])
    @shanghu = @tanwei.shanghus.first
    @gongyingshang = Gongyingshang.new
    @changshang = Changshang.new
    @diaoboshang = Diaoboshang.new
    @xiaozuofang = Xiaozuofang.new
  end
  
  def sh
    @shanghu = Shanghu.find(params[:id])
    @gongyingshang = Gongyingshang.new
    @changshang = Changshang.new
    @diaoboshang = Diaoboshang.new
    @xiaozuofang = Xiaozuofang.new
  end

  def search
    response.headers["Content-Type"] = "text/javascript; charset=utf-8"
    @gongyingshangs = Gongyingshang.find(:all, :conditions => ["name like ?", "%" + params[:shuju] + "%"])
    @changshangs = Changshang.find(:all, :conditions => ["name like ?", "%" + params[:shuju] + "%"])
    @xiaozuofangs = Xiaozuofang.find(:all, :conditions => ["name like ?", "%" + params[:shuju] + "%"])
    @diaoboshangs = Diaoboshang.find(:all, :conditions => ["name like ?", "%" + params[:shuju] + "%"])
    respond_to do |format|
    if @gongyingshangs != nil || @changshangs != nil|| @diaoboshangs != nil|| @xiaozuofangs != nil

      format.js { render :layout => false }
    else
      format.html { render :new }
      format.js { render :layout => false, :status => 406  }
    end
    end
  end
  
  def changshangsp
    @shangpin = Shangpin.new
    @shanghu = Shanghu.find(params[:shanghu_id])
    @shangjia = Changshang.find(params[:shangjia_id])


    #@sps为该商户的所有商品;@shangpins为商户目前 已备案的某厂家的所有商品，@laoshangpin_id为其id
    @sps = @shanghu.shangpins
    @shangpins = %w{}
    @laoshangpin_id = %w{}
    @sps.each do |s| 
       if s.changshang != nil
         if (s.changshang.id == params[:shangjia_id].to_i)
           @shangpins << s
           @laoshangpin_id << s.id
         end
       end
    end
     #调用方法（下面定义了）可添加商品：该商户没有备案的该厂家的其他产品
    ketianjiashangpins
  end
  
  def gongyingshangsp
    @shangpin = Shangpin.new
    @shanghu = Shanghu.find(params[:shanghu_id])
    @shangjia = Gongyingshang.find(params[:shangjia_id])

    #厂家商户 已备案的商品
    @sps = @shanghu.shangpins
    @shangpins = %w{}
    @laoshangpin_id = %w{}
    @sps.each do |s| 
       if s.gongyingshang != nil
         if (s.gongyingshang.id == params[:shangjia_id].to_i)
           @shangpins << s
           @laoshangpin_id << s.id
         end
       end

    end
        #调用方法（下面定义了）可添加商品：该商户没有备案的该厂家的其他产品
    ketianjiashangpins
  end
  
  def diaoboshangsp
    @shangpin = Shangpin.new
    @shanghu = Shanghu.find(params[:shanghu_id])
    @shangjia = Diaoboshang.find(params[:shangjia_id])

    #厂家商户 已备案的商品
    @sps = @shanghu.shangpins
    @shangpins = %w{}
    @laoshangpin_id = %w{}
    @sps.each do |s| 
       if s.diaoboshang != nil
         if (s.diaoboshang.id == params[:shangjia_id].to_i)
           @shangpins << s
           @laoshangpin_id << s.id
         end
       end
    end
        #调用方法（下面定义了）可添加商品：该商户没有备案的该厂家的其他产品
    ketianjiashangpins
  end
  
  def xiaozuofangsp
    @shangpin = Shangpin.new
    @shanghu = Shanghu.find(params[:shanghu_id])
    @shangjia = Xiaozuofang.find(params[:shangjia_id])

    #厂家商户 已备案的商品:@shangpins
    @sps = @shanghu.shangpins
    @shangpins = %w{}
    @laoshangpin_id = %w{}
    @sps.each do |s| 
       if s.xiaozuofang != nil
         if (s.xiaozuofang.id == params[:shangjia_id].to_i)
           @shangpins << s
           @laoshangpin_id << s.id
         end
       end
    end
    #调用方法（下面定义了）可添加商品：该商户没有备案的该厂家的其他产品
    ketianjiashangpins
  end
  
  #可添加商品：该商户没有备案的该厂家的其他产品
  def ketianjiashangpins
    @ketianjiashangpins = %w{}
    
    @shangjia.shangpins.each do |sp|
      @xinhao = true
      @shangpins.each do |a|
        if a.id == sp.id
          @xinhao = false
          break
        end
      end
      if @xinhao
      @ketianjiashangpins << sp
      end
    end
    @ketianjiashangpins
  end
end
