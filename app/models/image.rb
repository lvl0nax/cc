class Image
  include Mongoid::Document
  attr_accessible :photo
  mount_uploader :photo, ImageUploader
  belongs_to :grant
end