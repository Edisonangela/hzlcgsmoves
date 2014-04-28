class Shangpin < ActiveRecord::Base
  belongs_to :changshang
  belongs_to :gongyingshang
  belongs_to :diaoboshang
  belongs_to :xiaozuofang
  belongs_to :shangjia
  has_and_belongs_to_many :shanghus
  #attr_accessible :changshang_id,:gongyingshang_id,:diaoboshang_id,:xiaozuofang_id, :guige, :leixing, :name,:baozhuang,:danzhong
end
