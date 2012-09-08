class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  field :name
  mount_uploader :photo, ImageUploader
  
  #validates_presence_of :name
  validates_uniqueness_of  :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

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

  #has_and_belongs_to_many :evactivities, class_name: "Event", inverse_of: :participant
  #has_and_belongs_to_many :gractivities, class_name: "Grant", inverse_of: :participant
  #has_and_belongs_to_many :tractivities, class_name: "Training", inverse_of: :participant
  # index "role.name"
  # index :name, :unique => true, :background => true
   index({ name: 1 }, { unique: true, background: true })

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

  def juristic
    User.where(:role.name == "juristic")
  end

  def actions
    actions = []
    actions.concat( Event.all_in(:id => self.event_ids).to_a)
    actions.concat( Grant.all_in(:id => self.grant_ids).to_a)
    actions.concat( Training.all_in(:id => self.training_ids).to_a)
    actions.concat( Month.all.to_a) # TODO: add months only when month has any action
    return actions.sort!{|x,y| x.start_date <=> y.start_date}
  end

end
