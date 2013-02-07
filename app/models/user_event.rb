class UserEvent
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  
  field :user_id, :type => Integer
  field :event_parent_id, :type => Integer

  belongs_to :user
  belongs_to :event_parent

end
