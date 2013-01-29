# encoding: UTF-8
class Area
  include Mongoid::Document
  field :name, type: String
  has_and_belongs_to_many :users
  has_and_belongs_to_many :grants
  has_and_belongs_to_many :trainings
  has_and_belongs_to_many :events
  validates_uniqueness_of :name, :message => 'Сфера с таким названием уже существует'
end
