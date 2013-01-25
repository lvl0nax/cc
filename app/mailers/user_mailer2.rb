class UserMailer2 < ActionMailer::Base
  default from: "spam.ruby29@gmail.com"


  def register(user)
    @user = user
    @unisender ||= UniSender::Client.new("579fi6mwhe5ea7bj8z8sxt9htq44sygoyburwoto")
    @unisender.createList(:title => 'NewListUser')
    puts 'xxxxxxx'*3
    @list_ids = @unisender.getLists()['result'].first['id'].to_i
    @unisender.subscribe(:list_ids => @list_ids, :fields => )
	

    #puts @result
    #@list_ids = @result.first
    #puts @list_ids
    @url  = "http://example.com/login"
    mail(:to => user.email,from: "info@centercareer.ru", :subject => "Welcome to My Awesome Site")
  end
  
end
