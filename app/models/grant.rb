# encoding: utf-8
class Grant < EventParent

  has_many :requests, as: :requestable
  has_and_belongs_to_many :users
  #belongs_to :user

  field :nation
  field :hyperlink, :type => String # Link to external site with/without registration to event
  field :end_date, :type => Time
  field :visible, :type => Boolean
  field :direction, :type => Array

  validates_presence_of :title, :message => 'Обязательно'
  validates_presence_of :description, :message => 'Обязательно'

  field :vk
  field :twitter
  field :afisha
  field :fb
  field :cityspb
  field :timepad
  field :lookatme

  validates_format_of :vk, :with => /http:\/\/vk\.com\/.*/, :message => "Неправильный адрес",:allow_blank => true
  validates_format_of :twitter, :with => /http:\/\/(www)?\.twitter\.com\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :afisha, :with => /http:\/\/(www)?\.afisha\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :fb, :with => /http:\/\/(www)?\.facebook\.com\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :timepad, :with => /http:\/\/(.*?)\.timepad\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :lookatme, :with => /http:\/\/(.*?)\.lookatme\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true
  validates_format_of :cityspb, :with => /http:\/\/(www)?\.cityspb\.ru\/.*/, :message => "Неправильный адрес", :allow_blank => true



  def self.directions
    ["ЕСТЕСТВЕННЫЕ", "ГУМАНИТАРНЫЕ", "ОБЩЕСТВЕННЫЕ", "ТЕХНИЧЕСКИЕ", "МАТЕМАТИЧЕСКИЕ И IT", "ЛЮБАЯ"]
  end

  has_and_belongs_to_many  :areas
  has_one :image

  accepts_nested_attributes_for :areas, :image

  def self.search(areas)
    now = DateTime.now
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all
    if areas
      t = t.any_in(:direction => areas[:direction])
    end
  end

  def self.isearch
    now = DateTime.now
    t = self.where(:status => "ОДОБРЕНО").where(:start_date.gte => now).all
      t = t.any_in(:direction => self.directions)
    return t
  end

  def end_date=(params)
     self.start_date = self.start_date.change(:hour=>params.to_datetime.hour, :min=>params.to_datetime.min)
  end
end
