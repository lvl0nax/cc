# -*- encoding : utf-8 -*-

class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :nickname,              :type => String, :default => ""
  field :provider,              :type => String, :default => ""
  field :url,              :type => String, :default => ""
  field :username,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  #field :name
  mount_uploader :photo, ImageUploader
  
  #validates_presence_of :name
  validates_uniqueness_of  :email, :case_sensitive => false
  attr_accessible  :email, :password, :password_confirmation, :remember_me, :role_name #,:name
  attr_accessible :nickname, :provider, :url, :username
  validates_presence_of :email
  validates_presence_of :encrypted_password

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

  embeds_one :role
  embeds_one :compinfo
  embeds_one :resume

  has_and_belongs_to_many :trainings
  has_and_belongs_to_many :grants
  has_and_belongs_to_many :events
  has_many :requests

  has_many :authentications
  
  has_and_belongs_to_many :areas

  accepts_nested_attributes_for :resume, :autosave=> true
  #has_and_belongs_to_many :evactivities, class_name: "Event", inverse_of: :participant
  #has_and_belongs_to_many :gractivities, class_name: "Grant", inverse_of: :participant
  #has_and_belongs_to_many :tractivities, class_name: "Training", inverse_of: :participant
  # index "role.name"
  # index :name, :unique => true, :background => true
   #index({ name: 1 }, { unique: true, background: true })

   accepts_nested_attributes_for :role, :autosave=> true, :reject_if => :all_blank
  # TODO: Make roles as array. Its for nice view

  
  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  def calendar_title
    return "МОЙ КАЛЕНДАРЬ(" + (self.actions.count - Month.all.count).to_s + ")"
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
    return self.id
  end

  def role?(role)
      return self.role.try(:name).to_s == role.to_s
  end

  def role_name
    return self.role.name
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
    where(role_name: "admin")
  end

   def actions
    actions = []
    actions.concat( Event.where(:status => "ОДОБРЕНО").any_in(:id => self.event_ids).to_a)
    actions.concat( Grant.where(:status => "ОДОБРЕНО").any_in(:id => self.grant_ids).to_a)
    actions.concat( Training.where(:status => "ОДОБРЕНО").any_in(:id => self.training_ids).to_a)
    actions.concat( Month.all.to_a) # TODO: add months only when month has any action
    return actions.sort!{|x,y| x.start_date <=> y.start_date}
  end
  
  def created_actions
    acts = []
    acts.concat( Event.where(:owner => self.id).to_a)
    acts.concat( Grant.where(:owner => self.id).to_a)
    acts.concat( Training.where(:owner => self.id).to_a)
    acts.concat( Month.all.to_a) # TODO: add months only when month has any action
    #logger.debug "-----------UsersModel/created_actions---------------------------------"
    #acts.each do |a|
      #logger.debug a.start_date 
      #logger.debug a.class
      #logger.debug a.title
    #end
    return acts.sort!{|x,y| x.start_date <=> y.start_date}
  end

  def avatar
    if self.role?("employee")
      self.resume.photo
    else
    end
  end

  def self.find_for_facebook_oauth(access_token, role)
    if user = User.where(:url => access_token.info.urls.Facebook).first
      user
    else 
       @user = User.create!(
                   :provider => access_token.provider, 
                   :url => access_token.info.urls.Facebook, 
                   :username => access_token.extra.raw_info.name, 
                   # :name => access_token.extra.raw_info.name, 
                   :nickname => access_token.extra.raw_info.username, 
                   :email => access_token.extra.raw_info.email, 
                   :password => Devise.friendly_token[0,20])
      @user.create_role(:name => role)
    end
  end

  def self.find_for_vkontakte_oauth(access_token, role)
    if user = User.where(:url => access_token.info.urls.Vkontakte).first
      user
    else 
      @user = User.create!(
                   :provider => access_token.provider, 
                   :url => access_token.info.urls.Vkontakte, 
                   :username => access_token.info.name, 
                   # :name => access_token.info.name, 
                   :nickname => access_token.extra.raw_info.domain, 
                   :email => access_token.extra.raw_info.domain+'@vk.com', 
                   :password => Devise.friendly_token[0,20])
      @user.create_role(:name => role)
    end
  end

end
