#encoding: UTF-8
module ApplicationHelper
  def title
    base_title = "Центр карьеры"
    if @title.nil?
      base_title
    else
      @title
    end
  end


end
