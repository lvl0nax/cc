class Training
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  belongs_to :user
  has_many :requests, as: :requestable
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

  #attr_accessible :end_date, :start_date, :request_date
  

  ### TODO :
  # FIELD - Place of the event field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - Email to owners of the event 
  #
  # VALIDATIONS - required fields

end
