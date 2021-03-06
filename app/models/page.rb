class Page
  include Mongoid::Document
  field :title, :type => String
  field :content, :type => String
  field :meta_title, :type => String
  field :meta_keyword, :type => String
  field :meta_description, :type => String
  field :page_id, :type => String
  field :visible, :type => Boolean

  def self.visible
    self.where(:visible => true)
  end
end
