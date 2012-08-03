class Event
  include Mongoid::Document
  has_many :requests, as: :requestable
  field :title
  field :description
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions for registrations to the event
  field :area # area for examples IT, buildings and etc
  field :owner # User_id


  ### TODO :
  # FIELD - photo
  # FIELD - Place of the event field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - Email to owners of the event 
  #
  # VALIDATIONS - required fields



end
