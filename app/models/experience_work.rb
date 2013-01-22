class ExperienceWork
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes

  #attr_accessible :experience_company, :experience_from, :experience_to, :experience_position

  field :experience_company, :type => String
  field :experience_from, :type => Date
  field :experience_to, :type => Date
  field :experience_position, :type => String

  belongs_to :resume

end
