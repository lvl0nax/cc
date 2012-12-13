class Image
  include Mongoid::Document
  attr_accessible :photo
  embedded_in :grant
  mount_uploader :photo, ImageUploader
end