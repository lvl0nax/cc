class Grant
  include Mongoid::Document

  field :title
  field :description
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :cond # conditions fo
  field :area # area for examples IT, buildings and etc
  field :owner # User_id
  field :payment, :type => Boolean # for training
  field :worktype


  ### TODO :
  # QUESTIONS : may be we should take logotype of the owner-company from the company info page?
  # FIELD - Place of the owner-company field
  # FIELD - Date and time fields for the event and end of registration
  # FIELD - date when everebody can see results
  #
  #
  # VALIDATIONS - required fields

end
