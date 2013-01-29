# encoding: utf-8
class UserMailer2 < ActionMailer::Base
  default from: "spam.ruby29@gmail.com"

 def info_email(user)
  	@user = user #initiate user #user.email,
    mail(to: "vadim.motsuch@gmail.com")
  end

 def register(user)
    @user = user
    mail(:to => user.email,from: "info@centercareer.ru", :subject => "Welcome to My Awesome Site")
    id = unisender.getLists()['result'].first['id']

 end


def send_mail_template(id,name)
    @content = content(name)
    id_mes = unisender.createEmailMessage(:sender_name=>'ЦЕНТР КАРЬЕРЫ', :sender_email=>'spam.ruby29@gmail.com',
    :subject=>'You need your stuff', :list_id=>id, :lang=>'en',
    :body=>@content)['result']['message_id']
    unisender.createCampaign(id_mes,2)
end


def subscribe(list_id, email, phone,name,overwrite)
	unisender.subscribe(:list_ids=>list_id, :fields=>{:email=>""+email+"", :phone=>phone, :Name=>""+name+""},
		:overwrite=>overwrite)
end

  def spamer(id)
  	## TODO: initialize @users variable correctly
  	@user_list = []
    User.all.each do |user|
      unless user.resume.nil?
        if user.resume.delivery_email_enable == true or user.resume.delivery_phone_enable == true
          @user_list << user
        end
      end
    end
    @user_list.each do |user|
      @event_list = []
      user.areas.each do |u_area|
        u_area.grants.each do |u_a_grant|
          if u_a_grant.status == 'ОДОБРЕНО'
            @event_list << u_a_grant
          end
        end
        u_area.events.each do |u_a_event|
          if u_a_event.status == 'ОДОБРЕНО'
            @event_list << u_a_event
          end
        end
        u_area.trainings.each do |u_a_training|
          if u_a_training.status == 'ОДОБРЕНО'
            @event_list << u_a_training
          end
        end
        
      end
      str_name = user.resume.surname + ' ' + user.resume.name
      send_ind_email(id,str_name,user.email,@event_list)
    end
  end


  def send_ind_email(id,name,email,event_list)
    adress = root_url
    content = content(name,event_list,adress)
    
    unisender.sendEmail(
      :email=>email,
      :sender_name=> 'ЦЕНТР КАРЬЕРЫ', 
      :sender_email=>'spam.ruby29@gmail.com',    
      :subject=>'Hello', 
      :list_id=> id, 
      :lang=>'en',
      :body=> content)
  end

  def unisender
    @unisender ||= UniSender::Client.new("579fi6mwhe5ea7bj8z8sxt9htq44sygoyburwoto")
  end

  def get_content_list(event_list,adress)

    str =""
    
            event_list.each_with_index do |event,index|
              if event.class.name.eql?('Grant')
               str += content_grant(event,adress)
              elsif event.class.name.eql?('Event')
                str += content_event(event,adress)
              elsif event.class.name.eql?('Training')
                str += content_training(event,adress)
              end                  
              if index == 4
                break
              end
            end
      return str
  end

  def content(name, event_list,adress)
  array = get_content_list(event_list,adress)
  
  content = '<!DOCTYPE HTML>
          <html lang="en-US">
          <head>
            <meta charset="UTF-8">
            <title></title>
          </head>
          <body>
            <style type="text/css">
            *{
              margin:0;
              padding:0;
              font-family: Verdana;

            }
          </style>
          <table style="width:100%">
          <tr>
          <td>
          <img style="width:100%" src="'+adress+'/assets/header.png" alt="">
          </td>
          </tr>
          <tr>
          <td>
          <table style="width:650px; margin:0 auto;">
          <tr>
          <td>
          <span style="text-transform:uppercase; font-size:18px; padding: 30px 0 25px 0px; color:#354242; float:left;">Уважаемый, 
            <span style="color:#77a087;">'+name+'!</span>
          </span>
          <img  style="float:right; padding-top:20px; margin-right:20px; margin-bottom:20px;" src="'+adress+'/assets/logo.png" alt="">
          <span style="display:block; clear:both;"></span>
          <p style=" font-family: tahoma;  font-size:14px; padding: 0px 0 15px 0px; color:#354242;">Предлагаем Вам ознакомится с самыми интересными карьерными и професиональными мероприятиями, подобраными в соответствии с Вашыми интересами. Пополнить список интересующих Вас сфер можно в <a href="'+adress+'" style="font:tahoma 25px; color:#77a087;">личном кабинете </a></p>
          </td>
          </tr>
          <tr>
          <td>
           <table>'+array+'           
          </table>
          </td>
          </tr>
          <tr>
          <td style="text-transform:uppercase; font-size:14px; padding: 13px 0 13px 30px;  color:#354242;">
          <span style="float:left">желаем успеха, ваш центр карьеры</span>
          <a href="'+adress+'" style="font:tahoma 13px; color:#77a087; float:right; text-transform:none; margin-right:20px">centercareeer.ru </a>
          </td>
          </tr>
          </table>
          </td>
          </tr>
          <tr>
          <td>
          <img style="width:100%" src="'+adress+'/assets/footer.png" alt="">
          </td>
          </tr>
          </table>
          </body>
          </html>'
    return content
  end

  def content_grant(grant,adress)
    title = grant.title.to_s
    img=""
      unless grant.image_id.eql?("")
        img = Image.find(grant.image_id).photo.thumb
      else
        img = adress + "assets/contimg4.png"
      end
    grant_content = '<tr>
    <td>
    <table style="width:630px; border-left:10px solid #354242; border-right:10px solid #354242; border-top:1px solid #354242; border-bottom:1px solid #354242; background-color:white; margin-bottom:4px;">
    <tr>
      <td style="padding:15px 25px 5px 25px;">
        <span style="font-family:verdana; font-size:10px; color:#354242; float:left;">грант<br/>
          <img src="'+img+'" alt="">
        </span>
        <h3 style="font-family:verdana; font-size:18px; color:#354242; font-weight:normal; margin-left:80px;">'+title+'</h3>
        <p style="font-family:verdana; font-size:12px; color:#354242; font-weight:normal; margin-left:80px;">подача тезисов '+grant.start_date.strftime("%d %m %Y")+'//<br> с 09:00 до '+grant.start_date.strftime(" %H:%M ")+'</p>
        <span style="display:block; clear:both;"></span>
        <a href="'+adress+'" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#354242; font-weight:normal; margin-top:15px; display:block;">Подробнее ></a>
        <a href="https://www.google.com/calendar" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#354242; font-weight:normal; margin-top:5px; display:block;">+ в Google календарь</a>
        <span style="display:block; text-align:left; font-size: 10px; color: #354242; width:110px;">
          <br>
          '+grant.start_date.strftime("%d %B %Y")+' <br>
          '+grant.nation if grant.nation+'<br>
          09:00 - '+grant.start_date.strftime(" %H:%M ")+'
        </span>
      </td>
    </tr>
  </table></td></tr>'
 
  return grant_content
  end

  def content_event(event,adress)
    title = event.title.to_s
    img=""
      unless event.image_id.eql?("")
        img = Image.find(event.image_id).photo.thumb
      else
        img = adress + "assets/contimg5.png"
      end
    event_content = '<tr><td><table style="width:630px; border-left:10px solid #77a087; border-right:10px solid #77a087; border-top:1px solid #77a087; border-bottom:1px solid #77a087; background-color:white; margin-bottom:4px;">
    <tr>
      <td style="padding:15px 25px 5px 25px;">
        <span style="font-family:verdana; font-size:10px; color:#77a087; float:left;">событие<br/>
         <img src="'+img+' alt="">
        </span>
        <h3 style="font-family:verdana; font-size:18px; color:#77a087; font-weight:normal; margin-left:80px;">'+title+'</h3>
        <p style="font-family:verdana; font-size:12px; color:#77a087; font-weight:normal; margin-left:80px;">строк подачи резюме с '+ event.start_date.strftime("%d %m") +' до '+ event.request_date.strftime("%d %m") +'</p>
        <span style="display:block; clear:both;"></span>
        <a href="'+adress+'" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#77a087; font-weight:normal; margin-top:15px; display:block;">Подробнее ></a>
        <a href="https://www.google.com/calendar" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#77a087; font-weight:normal; margin-top:5px; display:block;">+ в Google календарь</a>
        <span style="display:block; text-align:left; font-size: 10px; color: #77A087; width:110px;">
          <br>
          '+event.start_date.strftime("%d/%m/%Y")+'<br>
          '+event.nation if event.nation+'<br>
          '+event.start_date.strftime("%H:%M")+' - '+event.end_date.strftime("%H:%M")+'
        </span>
      </td>
    </tr>
  </table></tr></td>'
  
  return event_content
  end

  def content_training(train,adress)
    title = train.title.to_s
    img=""
      unless train.image_id.eql?("")
        img = Image.find(train.image_id).photo.thumb
      else
        img = adress + "assets/contimg6.png"
      end
    train_content = '<tr><td><table style="width:630px; border-left:10px solid white; border-right:10px solid white; background-color:#c5d757; margin-bottom:4px;">
    <tr>
      <td style="padding:15px 25px 5px 25px">
        <span style="font-family:verdana; font-size:10px; color:white; float:left;">стажировка<br/>
          <img src="'+img+'" alt="">
        </span>
        <h3 style="font-family:verdana; font-size:18px; color:white; font-weight:normal; margin-left:80px;">'+title+'</h3>
        <p style="font-family:verdana; font-size:12px; color:white; font-weight:normal; margin-left:80px;">строк подачи резюме с '+ train.start_date.strftime("%d %m") +' до '+ train.request_date.strftime("%d %m") +'</p>
        <span style="display:block; clear:both;"></span>
        <a href="'+adress+'" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:white; font-weight:normal; margin-top:15px; display:block;">Подробнее ></a>
        <a href="https://www.google.com/calendar" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:white; font-weight:normal; margin-top:30px; display:block;">+ в Google календарь</a>
        <span style="display:block; text-align:left; font-size: 10px; color: white; width:110px;">
          <br>
          '+train.start_date.strftime("%d/%m/%Y")+'<br>
          '+train.nation if train.nation+'<br>
          '+train.start_date.strftime("%H:%M")+' - '+train.end_date.strftime("%H:%M")+'
        </span>
      </td>
    </tr>
  </table></tr></td>'
  
  return train_content
  end

end
