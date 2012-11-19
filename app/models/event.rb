# -*- encoding : utf-8 -*-
class Event
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  #has_many :requests, as: :requestable
  #belongs_to :user
  has_and_belongs_to_many :users#, class_name: "User", inverse_of: :evactivity

  field :title
  field :description
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions for registrations to the event
  field :areas # area for examples IT, buildings and etc
  field :owner # User_id
  field :nation # field as listing
  field :city # may be make as list of the towns
  field :street
  field :building
  field :place
  field :status
  field :direction, :type => Array
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :request_date, :type => DateTime
  field :kind
  field :x_coordinate, :type => Float
  field :y_coordinate, :type => Float

  validates_presence_of :title, :message => ''
  validates_presence_of :description, :message => ''
  validates_presence_of :direction, :message => ''  

  field :vk
  field :twitter
  field :afisha
  field :fb
  field :cityspb
  field :timepad
  field :lookatme

  validates :vk, format: { with: /http:\/\/(www)?\.vk\.com\/.*/, :message => "Неверный адрес"}, :allow_blank => true
  validates :twitter, format: { with: /http:\/\/(www)?\.twitter\.com\/.*/, :message => "Неверный адрес"}, :allow_blank => true
  validates :afisha, format: { with: /http:\/\/(www)?\.afisha\.ru\/.*/, :message => "Неверный адрес"  }, :allow_blank => true
  validates :fb, format: { with: /http:\/\/(www)?\.facebook\.com\/.*/, :message => "Неверный адрес"}, :allow_blank => true
  validates :timepad, format: { with: /http:\/\/(.*?)\.timepad\.ru\/.*/, :message => "Неверный адрес"}, :allow_blank => true
  validates :lookatme, format: { with: /http:\/\/(.*?)\.lookatme\.ru\/.*/, :message => "Неверный адрес"}, :allow_blank => true

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
    # if event_kinds
    #   event_kinds[:kind].delete("")
    #   #event_kinds[:kind]
      t = t.any_in(:kind => ["НАУЧНАЯ КОНФЕРЕНЦИЯ", "КАРЬЕРНОЕ СОБЫТИЕ", ""])
      logger.debug "++++++++++++++++++++++++++++++++"
      logger.debug t
    # end
    # if areas
    #   areas[:areas].delete("")
      t = t.any_in(:areas => areas) unless (Area.exists?)
    # end
    logger.debug "**********************************"
    logger.debug t
    return t
  end


end
