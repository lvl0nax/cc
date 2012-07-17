class Role
  include Mongoid::Document
  attr_accessible :name
  field :name
  embedded_in :User
end
