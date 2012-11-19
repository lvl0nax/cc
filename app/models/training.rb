# -*- encoding : utf-8 -*-
class Training
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  #belongs_to :user
  #has_many :requests, as: :requestable
  has_and_belongs_to_many :users #participants, class_name: "User", inverse_of: :tractivity
  #belongs_to :user

  field :title
  field :description
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions
  field :owner # User_id
  field :nation # field as listing
  field :city # may be make as list of the towns
  field :street
  field :building
  field :place
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :request_date, :type => DateTime #, :type => Array
  field :areas
  field :employment
  field :salary_type
  field :status
  field :direction, :type => Array
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

  ### TODO :
  # FIELD - Place of the event field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - Email to owners of the event 
  #
  # VALIDATIONS - required fields

  def self.search(salary_types, areas)
    now = DateTime.now
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all
    if salary_types
      #salary_types[:salary_type].delete("")
      #event_kinds[:kind]
      t = t.any_in(salary_type: salary_types[:salary_type]) unless (salary_types[:salary_type].blank?)
    end
    if areas
      #areas[:areas].delete("")
      t = t.any_in(:areas => areas[:areas]) unless (areas[:areas].blank?)
    end
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
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all
    logger.debug "+++++++++++++++++++++++++++++++++COUNT TRAINING1111"
      logger.debug t.count
    # if salary_types
    #   salary_types[:salary_type].delete("")
    #   #event_kinds[:kind]
      t = t.any_in(:salary_type => ["ОПЛАЧИВАЕМАЯ", "НЕОПЛАЧИВАЕМАЯ", ""] ) #unless (salary_types[:salary_type].blank?)
      logger.debug "+++++++++++++++++++++++++++++++++COUNT TRAINING22222"
      logger.debug t.count
    # end
    # if areas
    #   areas[:areas].delete("")
      t = t.any_in(:areas => areas) if (Area.exists?)
      logger.debug "+++++++++++++++++++++++++++++++++COUNT TRAINING33333"
      logger.debug t.count
    # end
    return t
  end


  def user
    User.where(id: self.owner).first
  end

end
