class Request
  include Mongoid::Document
  field :user_id
  field :evant_id
  field :evant_name

  ### TODO:
  # FIELD - date for event
  # Add all field which we want to see on user page.
end
