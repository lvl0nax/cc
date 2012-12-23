# -*- encoding : utf-8 -*-
class Month
  include Mongoid::Document
  field :name, type: String
  field :number, type: Integer

  def start_date
  	now = DateTime.now.beginning_of_month
  	case now.month <=> self.number
  		when 1
  			return DateTime.new(now.year+1,self.number,1,0,0,0,"+4")
  		when 0
  			return now
  		when -1
  			return DateTime.new(now.year,self.number,1,0,0,0,"+4")  		
  	end
  end
end

