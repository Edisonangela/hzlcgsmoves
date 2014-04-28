class Gongyingshang < Shangjia
  has_and_belongs_to_many :shanghus,:join_table => 'gongyingshangs_shanghus'
  has_many :shangpins,:dependent => :destroy
  #attr_accessible :dizhi, :leixing, :liutong, :name, :zhizhao
end
