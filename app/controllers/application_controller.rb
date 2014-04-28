class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
    #protect_from_forgery
  before_filter :changeCharset
  def changeCharset
    #@headers["Content-Type"] = "text/html; charset=utf-8"
    response.headers["Content-Type"] = "text/html; charset=utf-8"
  end
  
  before_filter :authorize, :except=> [:login, :register, :check_name, :tanweidaoru,:tanwei,:changshangbeian,:guifanbeian,:changshangbeiandaoru,:gongyingshangbeiandaoru,:xiaozuofangbeiandaoru,:guifandaoru,:weiguijiludaoru,:updatel,:deletel,:createl ]

  private
  def authorize  
    unless session[:user_id]
      flash[:notice]="请先登陆"
      redirect_to(:controller =>"users", :action=>"login")
    end
  end
  protect_from_forgery with: :exception
end
