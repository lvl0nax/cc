class Connection
  include Mongoid::Document

  field :authentication_id, type: String
  field :user_id, type: String
  field :facebook_id, type: String
  field :vkontakte_id, type: String
  belongs_to :user


end