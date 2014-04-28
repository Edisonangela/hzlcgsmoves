class User < ActiveRecord::Base
  #attr_accessible :name, :password ,:power
  #has_many :xuncharizhis
  #has_many :weiguijilus
  def try_to_login
  
    transaction do    
      User.find(:first,  
           :conditions=>["name=? and password=?", name, password]           
           )

    end
  end
end
