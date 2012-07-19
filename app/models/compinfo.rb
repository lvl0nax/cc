class Compinfo
  include Mongoid::Document
  embedded_in :User
  field :name, :type => String
  field :description, :type => String
end
