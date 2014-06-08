# -*- coding: utf-8 -*-
class Spot < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode

  def category_name
    Category::NAME[category_id.to_i]
  end
  
  module Category
    NONE = 0
    FOOTSAL = 1
    BASEBALL = 2
    SOCCER = 3

    NAME = {
      NONE => "指定なし",
      FOOTSAL => "フットサル",
      BASEBALL => "野球",
      SOCCER => "サッカー"
    }

    def self.category_list
      NAME.map{|k, v| [v, k]}
    end
  end
end
