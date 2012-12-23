# encoding: UTF-8
class EventParent
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes

  field :owner, :type => String
  field :title
  field :description
  field :start_date, :type => DateTime
  field :status

  has_many :user_events

  def self.filter
    now = DateTime.now
    self.where(:start_date => {'$gte' => now }, :status=>'ОДОБРЕНО')
  end

  def self.month(index, year)
    now = DateTime.now.change(:month => index + 1, :year=>year)
    self.where(:start_date => {'$gte' => now.beginning_of_month,'$lt' => now.end_of_month}, :status=>'ОДОБРЕНО')
  end

  def self.count_date
    now = DateTime.now
    self.where(:start_date => {'$gte' => now}, :status=>'ОДОБРЕНО').count
  end

end