# -*- encoding : utf-8 -*-

class User
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable#, :encryptable

  ## Database authenticatable
  #field :encryptable, :type => String
  field :email,              :type => String , :default => ""
  field :nickname,              :type => String, :default => ""
  field :provider,              :type => String, :default => ""
  field :url,              :type => String, :default => ""
  field :username,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :timenow, :type=>Integer, :default=>0
  #field :password_reset_sent_at, :type => DateTime
  #field :password_reset_token, :type => String
  #field :name
  mount_uploader :photo, ImageUploader
  
  #validates_presence_of :name
  #validates_uniqueness_of  :email, :case_sensitive => false
  attr_accessible  :email, :password, :password_confirmation, :remember_me, :role_name,
  :connection_user_id, :connection_facebook_id, :connection_vkontakte_id #,:name
  attr_accessible :nickname, :provider, :url, :username, :role, :compinfo, :connection

  validates :password, :confirmation =>{:message=>"Пароли не совпадают"}, :length => {:minimum => 6,:message => 'Слишком короткий пароль (нужно 6 символов)'}
  validates :email,:uniqueness => {:message=>"Такой e-mail уже зарегистрирован"}, :format => {:with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/,
                                                                                                               :message =>"E-mail имеет неверный формат" }

  validates :password, :email, :presence => {:message=>"Обязательно"}

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  field :provider,           :type => String

  embeds_one :role
  embeds_one :connection
  embeds_one :compinfo
  embeds_one :resume

  has_and_belongs_to_many :trainings
  has_and_belongs_to_many :grants
  has_and_belongs_to_many :events

  # has_one :connection

  has_many :requests
  has_many :user_events
  has_many :authentications
  has_and_belongs_to_many :areas



  field :directions, :type => Array

  accepts_nested_attributes_for :resume, :autosave=> true

  after_create :deliver_email, :subscribe_to_unisender
  # before_destroy :destroy_connection
  accepts_nested_attributes_for :role, :autosave=> true, :reject_if => :all_blank
  accepts_nested_attributes_for :connection, :autosave=> true

  def destroy_connection
    puts Connection.where(:user_id=>self.id).first
    # Connection.where(:user_id=>self.id).first.destroy
  end

  def create_connection
    self.connection = Connection.create(:user_id => self.id)
  end

  def deliver_email
  UserMailer2.register(self) unless self.email == ""
  end

  def subscribe_to_unisender
    #UserMailer.subscription
  end

  def available_areas
    areas_t = []
    Area.all.each do |area|
      areas_t << area unless self.area_ids.include?(area)
    end
    puts areas_t.inspect
    areas_t
  end

  def active_events
    trainings.where(:start_date.gt => Time.now).count +
    events.where(:start_date.gt => Time.now).count +
    grants.where(:start_date.gt => Time.now).count    
  end

  def name 
    unless self.resume.blank?
      return self.resume.name
    end
    unless self.compinfo.blank?
      return self.compinfo.name
    end
    unless self.provider.blank?
      return self.username
    end
    unless self.email.blank?
      return self.email.split("@").first
    end
      self.id
  end

  def role?(role)
      self.role.try(:name).to_s == role.to_s
  end

  def role_name
    self.role.name
  end

  #TODO: testing!!!
  def requested_event(evnt)
    !!self.requests.detect {|r| r.requestable_id == evnt._id}
  end

  def self.employers
    @@users = []
    User.all.each{|u| @@users << u if u.try(:role_name) == "employer"}
    @@users
  end
  def self.employees
    @@users = []
    User.all.each{|u| @@users << u if u.try(:role_name) == "employee"}
    @@users
  end

  def self.admins
    where(role_name: "admWz4y9j7WJ,Md7HN5lTfBin")
  end

   def actions
    actions = []
    actions.concat( Event.where(:status => "ОДОБРЕНО").any_in(:id => self.event_ids).to_a)
    actions.concat( Grant.where(:status => "ОДОБРЕНО").any_in(:id => self.grant_ids).to_a)
    actions.concat( Training.where(:status => "ОДОБРЕНО").any_in(:id => self.training_ids).to_a)

    months  = Month.all.to_a.keep_if do |m|
      actions.any? { |a| a.start_date.month.to_i == m.number }
    end

    actions.concat(months)
    actions.sort!{|x,y| x.start_date <=> y.start_date}
  end
  
  def created_actions
    acts = []
    acts.concat( Event.where(:owner => self.id).to_a)
    acts.concat( Grant.where(:owner => self.id).to_a)
    acts.concat( Training.where(:owner => self.id).to_a)
    months  = Month.all.to_a.keep_if do |m|
      acts.any? { |a| a.start_date.month.to_i == m.number }
    end
    acts.concat(months)

    acts.sort!{|x,y| x.start_date <=> y.start_date}
  end

  def avatar
    if self.role?("employee")
      self.resume.photo
    else
    end
  end

  def area_ids=(ids)
    self.areas = nil
    ids.each do |id|
      self.areas << Area.where(:id => id)
    end unless ids.nil?
  end

  def self.compinfo_names
     User.where(:compinfo => {'$ne' => nil})
  end

  def send_password_reset
    self.reset_password_token = generate_token(:reset_password_token)    
    self.reset_password_sent_at = Time.zone.now    
    self.save(:validate => false)
    UserMailer2.password_reset(self)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64      
    end #while User.exists?(column => self[column])
  end
 
end
