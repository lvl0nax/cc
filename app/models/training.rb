class Training
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  #belongs_to :user
  has_many :requests, as: :requestable
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
  field :areas, :type => Array
  field :employment
  field :salary_type

  mount_uploader :photo, ImageUploader

  attr_accessible :name
  

  ### TODO :
  # FIELD - Place of the event field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - Email to owners of the event 
  #
  # VALIDATIONS - required fields

  def self.search(salary_types, areas)
    t = self.all
    if salary_types
      salary_types[:salary_type].delete("")
      #event_kinds[:kind]
      t = t.in(salary_type: salary_types[:salary_type])
    end
    if areas
      areas[:areas].delete("")
      t = t.any_in(:areas => areas[:areas])
    end
    return t
  end

  def user
    User.where(id: self.owner).first
  end

end
