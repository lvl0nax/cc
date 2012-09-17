class Compinfo
  include Mongoid::Document
  embedded_in :User
  field :name
  field :city
  field :street
  field :building
  field :info
  field :hyperlink
  mount_uploader :photo, ImageUploader
  
end
