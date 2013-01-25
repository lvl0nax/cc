# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "spam.ruby29@gmail.com"

  def info_email(user)
  	@user = user #initiate user #user.email,
  	# mail(to: "center.cariery@gmail.com")
    mail(to: "vadim.motsuch@gmail.com")
  end

  def spamer
  	## TODO: initialize @users variable correctly
  	@users = User.all
  	@users.each { |u| info_email(u) }
  end

  def register(user)
    @unisender2 ||= UniSender::Client.new("579fi6mwhe5ea7bj8z8sxt9htq44sygoyburwoto")
    @unisender2.createList(:title => 'NewListUser')
    @user = user
    mail :to => user.email, :from => 'info@centercareer.ru', :subject => 'CareerCenter Registration'
  end  

  def self.subscription
    content = 'ЦЕНТР КАРЬЕРЫ'#mail(:subject => 'ЦЕНТР КАРЬЕРЫ').body.decoded
    self.unisender.send_email(
      :sender_name=> 'ЦЕНТР КАРЬЕРЫ', 
      :sender_email=>'uni.sender.gem@gmail.com',    
      :subject=>'You need your stuff', 
      :list_id=> self.unisender.subscribe_list.first, 
      :lang=>'en',
      :body=> content)
  end

  def self.unisender
    @unisender ||= UniSender::Client.new("579fi6mwhe5ea7bj8z8sxt9htq44sygoyburwoto")
  end

  def self.subscribe_lists    
    self.unisender.get_lists['result'].map{|list| list['id'].to_i}    
  end
  #@client.get_lists['result'].each do |item|
  #  puts "#{item['title']} #{item['id']}"


end
