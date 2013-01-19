#encoding: UTF-8
class Resume
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  embedded_in :User

  
  field :crop_x, :type => Integer
  field :crop_y, :type => Integer
  field :crop_w, :type => Integer
  field :crop_h, :type => Integer


  
  field :name, :type => String
  field :surname, :type => String
  field :gender, :type => String
  field :birthday, :type => Date
  field :home, :type => String
  field :education, :type => String
  field :university, :type => String
  field :faculty, :type => String
  field :experation, :type => Date
  field :description, :type => String
  field :delivery_email_enable, :type => Boolean
  field :delivery_email, :type => String
  field :delivery_phone_enable, :type => Boolean
  field :delivery_phone, :type => String
  field :sex

  mount_uploader :photo, ImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  has_many :experience_works, :dependent => :destroy
  accepts_nested_attributes_for :experience_works, :allow_destroy => true
  
  validate :picture_size_validation, :if => "photo?"
  validates_format_of :photo, :with => %r{\.(jpg|jpeg)$}i, :message => "Неверный формат" 

  def picture_size_validation
    errors[:photo] << "5MB" if photo.size > 5.megabytes
  end

  def crop_avatar
    photo.recreate_versions! if crop_x.present?
  end
  
end
