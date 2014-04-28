# encoding: utf-8
class UsersController < BaseController
  #main_nav_highlight :users
  defaults resource_class: User, collection_name: 'users', instance_name: 'user'
  # GET /users
  # GET /users.json
#  def index
#    @users = User.all#

#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @users }
#    end
#  end#

#  # GET /users/1
#  # GET /users/1.json
#  def show
#    @user = User.find(params[:id])#

#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @user }
#    end
#  end#

#  # GET /users/new
#  # GET /users/new.json
#  def new
#    @user = User.new#

#    respond_to do |format|
#      format.html # new.html.erb
#      format.json { render json: @user }
#    end
#  end#

#  # GET /users/1/edit
#  def edit
#    @user = User.find(params[:id])
#  end#

#  # POST /users
#  # POST /users.json
#  def create
#    @user = User.new(params[:user])#

#    respond_to do |format|
#      if @user.save
#        format.html { redirect_to @user, notice: 'User was successfully created.' }
#        format.json { render json: @user, status: :created, location: @user }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
#      end
#    end
#  end#

#  # PUT /users/1
#  # PUT /users/1.json
#  def update
#    @user = User.find(params[:id])#

#    respond_to do |format|
#      if @user.update_attributes(params[:user])
#        format.html { redirect_to @user, notice: 'User was successfully updated.' }
#        format.json { head :no_content }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @user.errors, status: :unprocessable_entity }
#      end
#    end
#  end#

#  # DELETE /users/1
#  # DELETE /users/1.json
#  def destroy
#    @user = User.find(params[:id])
#    @user.destroy#

#    respond_to do |format|
#      format.html { redirect_to users_url }
#      format.json { head :no_content }
#    end
#  end

  def login
    #binding.pry
    if request.get?
      session[:user_id]=nil 
      @user = User.new
  
    else
      
      @user=User.new(users_params)

      @errors = Array.new 
#binding.pry
      if params[:user][:name].to_s.empty?     
        flash[:notice]='用户名不能为空'
        redirect_to :controller=>"users", :action=>"login"
      

      elsif params[:user][:password].to_s.empty? 
        flash[:notice]='请输入密码'
        redirect_to :controller=>"users", :action=>"login"   

      else

        logged_in_user=@user.try_to_login
        # logged_in_user
        if !logged_in_user.to_s.empty?
          # Session
          session[:user_id]=logged_in_user.id
          session[:user_power]=logged_in_user.power
          redirect_to :controller=>"shanghus", :action=>"beianchaxun"
        else
          flash[:notice]="用户名或密码错误！"
          redirect_to :controller=>"users", :action=>"login"

        end
      end
    end

  end

  private
    def users_params
      params.fetch(:user, {}).permit(:name,:password)
      #params.require(:user).permit！#(:name,:password)
    end
end
