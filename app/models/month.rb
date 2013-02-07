# -*- encoding : utf-8 -*-
class Month < EventParent
  include Mongoid::Document
  field :name, type: String
  field :number, type: Integer
  
  def start_date
  	DateTime.now.change(:month=>number).beginning_of_month
  end
end

