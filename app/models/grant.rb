# 3-*- encoding : utf-8 -*-
class Grant
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  has_many :requests, as: :requestable
  has_and_belongs_to_many :users #participants, class_name: "User", inverse_of: :gractivity
  #belongs_to :user
  field :title

  field :owner
  field :description
  field :nation
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :request_date, :type => DateTime  
  field :direction, :type => Array
  field :end_point, :type => Array
  field :status
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

  def self.directions
    ["ЕСТЕСТВЕННЫЕ", "ГУМАНИТАРНЫЕ", "ОБЩЕСТВЕННЫЕ", "ТЕХНИЧЕСКИЕ", "МАТЕМАТИЧЕСКИЕ И IT", "ЛЮБАЯ"]
  end

  mount_uploader :photo, ImageUploader

  ### TODO :
  # QUESTIONS : may be we should take logotype of the owner-company from the company info page?
  # FIELD - Place of the owner-company field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - date when everebody can see results
  #
  #
  # VALIDATIONS - required fields
  def self.search(areas)
    now = DateTime.now
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all
    if areas
      #areas[:direction].delete("")
      t = t.any_in(:direction => areas[:direction])
    end
    logger.debug "**********************************"
    logger.debug t
    return t
  end
  def self.isearch
    now = DateTime.now
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all
  
      t = t.any_in(:direction => self.directions)
    logger.debug "**********************************"
    logger.debug t
    return t
  end

  def self.month(index, options = nil)
    now = DateTime.now.to_date.change(:month => index)
    self.where(:start_date => {'$gte' => now.beginning_of_month, '$lt' => now.end_of_month}).first
  end

end
