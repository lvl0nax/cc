class Image
  include Mongoid::Document
  attr_accessible :photo
  mount_uploader :photo, ImageUploader
  belongs_to :grant
  belongs_to :training
  belongs_to :event
end