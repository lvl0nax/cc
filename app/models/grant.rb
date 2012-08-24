class Grant
  include Mongoid::Document
  has_many :requests, as: :requestable
  belongs_to :user
  field :title
  field :description
  field :nation
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :request_date, :type => DateTime
  field :direction, :type => Array
  field :end_point, :type => Array
  mount_uploader :photo, ImageUploader

  ### TODO :
  # QUESTIONS : may be we should take logotype of the owner-company from the company info page?
  # FIELD - Place of the owner-company field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - date when everebody can see results
  #
  #
  # VALIDATIONS - required fields

end
