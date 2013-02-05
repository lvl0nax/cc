#encoding: UTF-8
class Compinfo
  include Mongoid::Document
  embedded_in :User

  field :crop_x, :type => Integer
  field :crop_y, :type => Integer
  field :crop_w, :type => Integer
  field :crop_h, :type => Integer


  field :name
  field :city
  field :street
  field :building
  field :info
  field :hyperlink

  mount_uploader :photo, ImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  validate :picture_size_validation, :if => "photo?"
  validates_format_of :photo, :with => %r{\.(jpg|jpeg)$}i, :message => "Неверный формат", :if => "photo?"


  def picture_size_validation
    errors[:photo] << "5MB" if photo.size > 5.megabytes
  end

  def crop_avatar
    photo.recreate_versions! if crop_x.present?
  end

end
