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

 validate :picture_size_validation, :if => "photo?"  

  def picture_size_validation
    errors[:photo] << "5MB" if photo.size > 5.megabytes
  end

end
