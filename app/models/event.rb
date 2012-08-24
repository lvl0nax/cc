class Event
  include Mongoid::Document
  has_many :requests, as: :requestable
  belongs_to :user
  field :title
  field :description
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions for registrations to the event
  field :areas, :type => Array # area for examples IT, buildings and etc
  field :owner # User_id
  field :nation # field as listing
  field :city # may be make as list of the towns
  field :street
  field :building
  field :place
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :request_date, :type => DateTime
  field :kind, :type => Array
  mount_uploader :photo, ImageUploader
  #field :area_types, :type => Array


  ### TODO :
  # FIELD - photo
  # FIELD - Place of the event field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - Email to owners of the event 
  #
  # VALIDATIONS - required fields



end
