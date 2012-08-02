class Request
  include Mongoid::Document
  referenced_in :user
  referenced_in :training
  #field :user_id
  #field :evant_id
  field :content
  #field :evant_name
  field :status

  field :type
  field :ref


  ### TODO:
  # FIELD - date for event
  # Add all field which we want to see on user page.
end
