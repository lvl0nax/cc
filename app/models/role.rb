class Role
  include Mongoid::Document
  field :name
  embedded_in :User
end
