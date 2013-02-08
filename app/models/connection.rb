class Connection
  include Mongoid::Document
  attr_accessible :user_id, :facebook_id,:vkontakte_id
  field :authentication_id, type: String
  field :user_id, type: String
  field :facebook_id, type: String
  field :vkontakte_id, type: String
  embedded_in :User

end