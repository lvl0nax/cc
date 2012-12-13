# encoding: utf-8
class Grant < EventParent

  has_many :requests, as: :requestable
  has_and_belongs_to_many :users #participants, class_name: "User", inverse_of: :gractivity
  #belongs_to :user

  field :owner
  field :nation
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :end_date, :type => DateTime
  field :request_date, :type => DateTime  
  field :direction, :type => Array
  field :end_point, :type => Array
  field :x_coordinate, :type => Float
  field :y_coordinate, :type => Float

  validates_presence_of :title, :message => 'Обязательно'
  validates_presence_of :description, :message => 'Обязательно'


  def self.directions
    ["ЕСТЕСТВЕННЫЕ", "ГУМАНИТАРНЫЕ", "ОБЩЕСТВЕННЫЕ", "ТЕХНИЧЕСКИЕ", "МАТЕМАТИЧЕСКИЕ И IT", "ЛЮБАЯ"]
  end

  embeds_one :image
  accepts_nested_attributes_for :image

  ### TODO :
  # QUESTIONS : may be we should take logotype of the owner-company from the company info page?
  # FIELD - Place of the owner-company field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - date when everebody can see results
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

  def end_date=(params)
     self.start_date = self.start_date.change(:hour=>params.to_datetime.hour,
                                              :min=>params.to_datetime.min)
  end

  #def image=(param)
  #  self.image = File.open(Rails.root.join('public', param[1..-1]))
  #  self.image.save
  #end

end
