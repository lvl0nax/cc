# -*- encoding : utf-8 -*-
class Training < EventParent
  #belongs_to :user
  #has_many :requests, as: :requestable
  has_and_belongs_to_many :users #participants, class_name: "User", inverse_of: :tractivity
  #belongs_to :user

  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions
  field :owner, :type=>String
  field :nation # field as listing
  field :city # may be make as list of the towns
  field :street
  field :building
  field :place
  field :end_date, :type => DateTime
  field :tmp_date, :type => DateTime
  field :tmp_end_date, :type => DateTime
  field :request_date, :type => DateTime #, :type => Array
  field :request_hour, :type => DateTime
  field :employment, :type => Array
  field :areas
  field :employment
  field :salary, :type => Integer
  field :salary_type, :type=>Array
  field :direction, :type => Array
  field :x_coordinate, :type => Float
  field :y_coordinate, :type => Float

  field :visible, :type => Boolean

  validates_presence_of :title, :message => 'Обязательно'
  validates_presence_of :description, :message => 'Обязательно'

  has_and_belongs_to_many  :areas
  has_one :image


  accepts_nested_attributes_for :areas, :image

  def self.salary_type
    %w[НЕОПЛАЧИВАЕМАЯ OПЛАЧИВАЕМАЯ]
  end

  def self.employment
    ["НАУЧНЫЕ КОНФЕРЕНЦИЯ" ,"КАРЬЕРНЫЕ СОБЫТИЕ"]
  end

  def user
    User.where(id: self.owner).first
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
