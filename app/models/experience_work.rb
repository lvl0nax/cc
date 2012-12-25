class ExperienceWork
  include Mongoid::Document

  field :experience_company, :type => String
  field :experience_from, :type => String
  field :experience_to, :type => String
  field :experience_position, :type => String

  belongs_to :resume
end
