class Role
  include Mongoid::Document
  attr_accessible :name
  field :name, :default => 'employee'
  embedded_in :User
end
