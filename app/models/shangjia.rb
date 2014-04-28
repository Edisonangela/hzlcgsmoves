class Shangjia < ActiveRecord::Base
  has_many :shangpins ,:dependent => :destroy
  #attr_accessible :dizhi, :leixing, :name
end
