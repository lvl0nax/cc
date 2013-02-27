class ExperienceWork
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes

  #attr_accessible :experience_company, :experience_from, :experience_to, :experience_position

  field :experience_company, :type => String
  field :experience_from, :type => Date
  field :experience_to, :type => Date
  field :experience_position, :type => String

  belongs_to :resume

  def experience_from_formatted
    self.experience_from.strftime('%d.%m.%Y') if self.experience_from?
  end
 
  def experience_from_formatted=(value)
    self.experience_from = Time.zone.parse(value)
  end 

  def experience_to_formatted
    self.experience_to.strftime('%d.%m.%Y') if self.experience_to?
  end
 
  def experience_to_formatted=(value)
    self.experience_to = Time.zone.parse(value)
  end 
end
