#encoding: UTF-8
class Resume
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes  
  embedded_in :User

 # attr_accessible :experience_works_attributes, :photo, :name, :surname, :sex, :home, :education, :university, :faculty, :description, :delivery_email_enable, :delivery_email, :delivery_phone_enable, :delivery_phone, :birthday, :experation
 
  field :crop_x, :type => Integer
  field :crop_y, :type => Integer
  field :crop_w, :type => Integer
  field :crop_h, :type => Integer
  
  field :name, :type => String, :default => ""
  field :surname, :type => String, :default => ""
  field :gender, :type => String, :default => ""
  field :birthday, :type => Date
  field :home, :type => String, :default => ""
  field :education, :type => String, :default => ""
  field :university, :type => String, :default => ""
  field :faculty, :type => String, :default => ""
  field :experation, :type => Date
  field :description, :type => String, :default => ""
  field :delivery_email_enable, :type => Boolean
  field :delivery_email, :type => String , :default => ""
  field :delivery_phone_enable, :type => Boolean
  field :delivery_phone, :type => String, :default => ""
  field :sex, :type=>String, :default => ""

  mount_uploader :photo, ImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  has_many :experience_works, :dependent => :destroy
  accepts_nested_attributes_for :experience_works, :allow_destroy => true
  
  validate :photo,  :size => { :in => 0..5.megabytes }
  validates_format_of :photo, :with => %r{\.(jpg|jpeg)$}i, :message => "Неверный формат",  :if => "photo?"

  def picture_size_validation
    errors[:photo] << "5MB" if photo.size > 5.megabytes
  end

  def crop_avatar
    photo.recreate_versions! if crop_x.present?
  end


  def birthday_formatted
    self.birthday.strftime('%d.%m.%Y') if self.birthday?
  end
 
  def birthday_formatted=(value)
    self.birthday = Time.zone.parse(value)
  end  

  def experation_formatted
    self.experation.strftime('%d.%m.%Y') if self.experation?
  end
 
  def experation_formatted=(value)
    self.experation = Time.zone.parse(value)
  end  
end
