class Request
  include Mongoid::Document
  belongs_to :user
  #referenced_in :training
  belongs_to :requestable, polymorphic: true
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
