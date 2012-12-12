# -*- encoding : utf-8 -*-
class Event < EventParent

  #has_many :requests, as: :requestable
  #belongs_to :user
  has_and_belongs_to_many :users#, class_name: "User", inverse_of: :evactivity

  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions for registrations to the event
  field :areas # area for examples IT, buildings and etc
  field :owner # User_id
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

  validates_presence_of :title, :message => 'Обязательно'
  validates_presence_of :description, :message => 'Обязательно'

  field :vk
  field :twitter
  field :afisha
  field :fb
  field :cityspb
  field :timepad
  field :lookatme

  validates_format_of :vk, :with => /http:\/\/vk\.com\/.*/, :message => "Неправильный адрес",:allow_blank => true
  validates_format_of :twitter, :with => /http:\/\/(www)?\.twitter\.com\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :afisha, :with => /http:\/\/(www)?\.afisha\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :fb, :with => /http:\/\/(www)?\.facebook\.com\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :timepad, :with => /http:\/\/(.*?)\.timepad\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :lookatme, :with => /http:\/\/(.*?)\.lookatme\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :cityspb, :with => /http:\/\/(www)?\.cityspb\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true

  mount_uploader :photo, ImageUploader
  

  #field :area_types, :type => Array


  ### TODO :
  # FIELD - photo
  # FIELD - Place of the event field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - Email to owners of the event 
  #
  # VALIDATIONS - required fields
  def self.search(event_kinds, areas)
    now = DateTime.now
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all #TODO: select events from current date to year later
    if event_kinds
      #event_kinds[:kind].delete("")
      #event_kinds[:kind]
      t = t.any_in(kind: event_kinds[:kind])
      logger.debug "++++++++++++++++++++++++++++++++"
      logger.debug t
    end
    if areas
      #areas[:areas].delete("")
      t = t.any_in(:areas => areas[:areas]) unless (areas[:areas].blank?)
    end
    logger.debug "**********************************"
    logger.debug t
    return t
  end
  def self.isearch
    now = DateTime.now
    areas = []
    areas.clear
    Area.each do |a|
      areas << a.id
    end
    areas << ""
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all #TODO: select events from current date to year later
      t = t.any_in(:kind => ["НАУЧНАЯ КОНФЕРЕНЦИЯ", "КАРЬЕРНОЕ СОБЫТИЕ", ""])
      t = t.any_in(:areas => areas) unless (Area.exists?)
    return t
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
