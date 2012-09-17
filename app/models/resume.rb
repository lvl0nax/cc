class Resume
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  embedded_in :User
  field :name, :type => String
  field :surname, :type => String
  field :gender, :type => String
  field :birthday, :type => Date
  field :home, :type => String
  field :education, :type => String
  field :university, :type => String
  field :faculty, :type => String
  field :experation, :type => String
  field :description, :type => String
  field :delivery_email_enable, :type => Boolean
  field :delivery_email, :type => String
  field :delivery_phone_enable, :type => Boolean
  field :delivery_phone, :type => String

end
