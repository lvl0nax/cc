# -*- encoding : utf-8 -*-
class Event < EventParent

  #has_many :requests, as: :requestable
  #belongs_to :user
  has_and_belongs_to_many :users#, class_name: "User", inverse_of: :evactivity

  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions for registrations to the event
  field :areas # area for examples IT, buildings and etc
  field :owner, :type=>String
  field :nation # field as listing
  field :city # may be make as list of the towns
  field :street
  field :building
  field :place
  field :direction, :type => Array
  field :end_date, :type => DateTime
  field :tmp_date, :type => DateTime
  field :tmp_end_date, :type => DateTime
  field :request_date, :type => DateTime
  field :request_hour, :type => DateTime
  field :kind
  field :x_coordinate, :type => Float
  field :y_coordinate, :type => Float
  field :visible, :type => Boolean
  field :payment, :type => Array
  validates_presence_of :title, :message => 'Обязательно'
  validates_presence_of :description, :message => 'Обязательно'

  mount_uploader :photo, ImageUploader

  field :area_types, :type => Array

  def self.area_types
    ["НАУЧНЫЕ КОНФЕРЕНЦИИ", "КАРЬЕРНЫЕ СОБЫТИЯ"]
  end

  has_and_belongs_to_many  :areas
  has_one :image


  accepts_nested_attributes_for :areas, :image


 def self.payment
    %w[НЕОПЛАЧИВАЕМАЯ ОПЛАЧИВАЕМАЯ]
  end

  def tmp_date=(params)
    self.start_date = self.start_date.change(:hour=>params.to_datetime.hour,
                                             :min=>params.to_datetime.min)
    self.end_date = DateTime.new
    self.end_date = self.end_date.change(:year => self.start_date.year,
                                         :month => self.start_date.month,
                                         :day => self.start_date.day)
  end

  def tmp_end_date=(params)
    self.end_date = self.end_date.change(:hour => params.to_datetime.hour,
                                         :min => params.to_datetime.min)
  end

  def request_hour=(params)
    self.request_date = self.request_date.change(:hour => params.to_datetime.hour,
                                                 :min => params.to_datetime.min)
  end

end
