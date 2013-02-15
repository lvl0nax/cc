# encoding: utf-8
class UserMailer2 < ActionMailer::Base
  default from: "centercareer0@gmail.com"

 def info_email(user)
    @user = user #initiate user #user.email,
    mail(to: "vadim.motsuch@gmail.com")
  end

 def register(user)
    @user = user
    @link = root_url
    
    # mail(:to => user.email,from: "info@centercareer.ru", :subject => "Регистрация на сайте Центр Карьеры", :content_type => 'text/html')
    id = unisender.getLists()['result'].first['id']
    send_mail_reg(id,@user)

 end

  # def register(user)
  #   recipients   user.email
  #   subject      "New account information"
  #   from         "system@example.com"
  #   body         :user => recipient
  #   content_type "text/html"
  # end

  def send_mail_reg(id,user)    
    content = content_register(user)
     unisender.sendEmail(
      :email=>user.email,
      :sender_name=> 'ЦЕНТР КАРЬЕРЫ', 
      :sender_email=>'centercareer0@gmail.com',    
      :subject=>'Регистрация на сайте Центр Карьеры', 
      :list_id=> id, 
      :lang=>'ru',
      :body=> content)
    
  end

  def content_register(user)
    user_name =  user.name
    user_email = user.email
    user_password = user.password
    content = '<!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>        
        <p>Спасибо за регистрацию!</p>

    <p>Здравствуйте, '+user_name+' !</p>

    <p>Для того чтобы закончить регистрацию и приступить 
    к составлению своего собственного календаря Вам присвоены 
    логин и пароль на нашем сайте. Их необходимо использовать при 
    первом входе на сайт, далее они могут быть изменены в <a href="http://cc.net-simple.ru">Личном Кабинете</a></p>

    <p>логин: '+user_email+' <br />
    пароль: '+user_password+'</p>

    <p>С уважением,<br />
    http://centercareer.ru</p>
      </body>
    </html>'
    return content
  end

def send_mail_template(id,user)
    @content = register_content(user)
    id_mes = unisender.createEmailMessage(:sender_name=>'ЦЕНТР КАРЬЕРЫ', :sender_email=>'centercareer0@gmail.com',
    :subject=>'Регистрация на сайте Центр Карьеры', :list_id=>id, :lang=>'en',
    :body=>@content)['result']['message_id']
    unisender.createCampaign(id_mes,2)
end

def register_content(user)
  content = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>
<body>
<p><font color="#2E7BE4"><em><strong>Здравствуйте!</strong></em></font></p>
<p align="justify">Здесь находится текст Вашего письма, <strong><font color="#CA9E64">при получении адресатом письма, данный участок текста будет коричневого цвета</font></strong>. При создании писем используйте стандартные HTML теги для корректного отображения элементов форматирования текста, при просмотре получателем, как с использованием веб-интерфейсов (Yandex.ru, Mail.ru, Email.ru и т.п.), так и с использованием почтовых сборщиков (Outlook, The Bat и т.п.).</p>
<p>
  <font color="#2E7BE4"><strong><i>С Уважением</i></strong><br>
    <strong>EMailFinder</strong><br>
    <strong>8&nbsp;900&nbsp;800-00-00</strong><br>
  <em><a href="mailto:info@emailfinder.ru">info@emailfinder.ru</a></em></font>
</p>
</body>
</html>'
return content
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
      :sender_email=>'centercareer0@gmail.com',    
      :subject=>'Рассылка', 
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
              if event.class.name.eql?('Training')
               str += content_training(event,adress)
              elsif event.class.name.eql?('Event')
                str += content_event(event,adress)
              elsif event.class.name.eql?('Grant')
                str += content_grant(event,adress)
              end                  
              if index == 4
                break
              end
            end
      return str
  end

  def content(name, event_list,adress)
  array = get_content_list(event_list,adress)
# f = File.new('file2.html', 'w')
# f.puts(array)
# f.close
  content = '<meta charset="UTF-8">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td><img width="100%" src="'+adress+'assets/header.png" alt=""></td>
  </tr>
  <tr>
    <td align="center">
      <table width="650" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td height="90"><font size="4" color="#354242" face="Verdana">УВАЖАЕМЫЙ, <font size="4" color="#77a087" face="Verdana">'+name+'!</font></font></td>
          <td align="right"><img src="'+adress+'assets/logo.png" alt=""></td>
        </tr>
        <tr>
          <td rowspan="2"><font size="2" color="#354242" face="Tahoma">Предлагаем Вам ознакомится с самыми интересными карьерными и професиональными мероприятиями, подобраными в соответствии с Вашыми интересами. Пополнить список интересующих Вас сфер можно в <a href="'+adress+'"><font size="2" color="#77a087" face="Tahoma">личном кабинете </font></a></font></td>
        </tr>
      </table>
      <br>'+array+'
      <table width="650" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td height="55"><font size="3" color="#354242" face="Verdana">ЖЕЛАЕМ УСПЕХА, ВАШ ЦЕНТР КАРЬЕРЫ</font></td>
          <td align="right"><a><font size="3" color="#77a087" face="Tahoma">centercareer.ru</font></a></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td><img width="100%" src="'+adress+'assets/header.png" alt=""></td>
  </tr>
</table>'
    return content
  end

  def content_training(train,adress)
    title = train.title.to_s
    img=""
      unless train.image_id.eql?("")
        img = Image.find(train.image_id).photo.thumb
      else
        img = adress + "assets/contimg6.png"
      end
      if train.nation
      nation = train.nation 
      else
      nation = ""
      end
      train_content='<table width="610" cellpadding="20" cellspacing="0" border="0" bgcolor="#c5d757">
        <tr>
          <td height="120">
            <font size="2" color="white" face="Verdana">
              <table>
                <tr>
                  <td valign="top" align="left" width="90">
                    <font size="1" color="white" face="Verdana">стажировка</font><br>
                    <img src="'+img+'" alt="">
                  </td>
                  <td valign="top" align="left">
                    <font size="3" color="white" face="Verdana">'+title+'</font><br>
                    <font size="1" color="white" face="Verdana">&nbsp;</font><br>
                    <font size="2" color="white" face="Verdana">строк подачи резюме с '+ Russian::strftime(event.start_date, "%d %B") +' до '+ Russian::strftime(event.request_date, "%d %B") +'</font>
                    <font size="1" color="white" face="Verdana">&nbsp;</font><br>
                    <font size="1" color="white" face="Verdana">&nbsp;</font><br>
                  </td>
                  <td width="10" align="left"><img src="'+adress+'assets/separator.png" alt=""></td>
                      <td width="110" cellpadding="0"><font size="1" color="#77a087" face="Verdana">
                       '+train.start_date.strftime("%d/%m/%Y")+'<br>
                        '+nation+'<br>
                        '+train.start_date.strftime("%H:%M")+' - '+train.end_date.strftime("%H:%M")+'
                      </font></td>
                </tr>
              </table>
              <table>
                <tr>
                  <td rowspan="2" valign="top" align="left">
                   <a href="'+adress+'?event_id='+train.id.to_s+'"><font size="1" color="#77a087" face="Verdana">ПОДРОБНЕЕ ></font></a><br>
                    <a href="#"><font size="1" color="white" face="Verdana">+ В GOOGLE КАЛЕНДАРЬ</font></a>
                  </td>
                </tr>
              </table>
            </font>
          </td>
        </tr>
      </table><br>'
  return train_content
  end

  def content_grant(grant,adress)
    title = grant.title.to_s
    img=""
      unless grant.image_id.eql?("")
        img = adress + Image.find(grant.image_id).photo.thumb.to_s
      else
        img = adress + "assets/contimg4.png"
      end
      if grant.nation
        nation = grant.nation 
      else
        nation = ""
      end
    grant_content = '<table width="630" align="center" cellpadding="2" cellspacing="0" border="0" bgcolor="#354242">
        <tr>
          <td>
            <table width="610" align="center" cellpadding="20" cellspacing="0" border="0" bgcolor="white">
              <tr>
                <td>
                  <table width="570" align="center" cellpadding="0" cellspacing="0" border="0" bgcolor="white">
                    <tr>
                      <td valign="top" align="left" width="90">
                        <font size="1" color="#354242" face="Verdana">грант</font><br>
                        <img src="'+img+'" alt="">
                      </td>
                      <td>
                        <font size="3" color="#354242" face="Verdana">'+title+'</font><br>
                        <font size="1" color="#354242" face="Verdana">&nbsp;</font><br>
                        <font size="2" color="#354242" face="Verdana">строк подачи резюме с 9:00 до '+ grant.start_date.strftime("%H:%M") +'</font>
                        <font size="1" color="#354242" face="Verdana">&nbsp;</font><br>
                        <font size="1" color="#354242" face="Verdana">&nbsp;</font><br>
                      </td>
                      <td width="10" align="left"><img src="'+adress+'assets/separator.png" alt=""></td>
                      <td width="110" cellpadding="0"><font size="1" color="#354242" face="Verdana">
                        '+grant.start_date.strftime("%d/%m/%Y")+'<br>
                        '+nation+'<br>
                        09:00 - '+grant.start_date.strftime("%H:%M")+'
                    </tr>
                  </table>    
                  <table width="570" align="center" cellpadding="0" cellspacing="0" border="0" bgcolor="white">
                    <tr>
                      <td rowspan="2" valign="top" align="left">
                        <a href="'+adress+'?event_id='+grant.id.to_s+'"><font size="1" color="#354242" face="Verdana">ПОДРОБНЕЕ ></font></a><br>
                        <a href="https://www.google.com/calendar"><font size="1" color="#354242" face="Verdana">+ В GOOGLE КАЛЕНДАРЬ ></font></a>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table><br>'
 
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
      if event.nation
        nation = event.nation 
      else
        nation = ""
      end
    event_content = '<table width="630" align="center" cellpadding="2" cellspacing="0" border="0" bgcolor="#77a087">
        <tr>
          <td>
            <table width="610" align="center" cellpadding="20" cellspacing="0" border="0" bgcolor="white">
              <tr>
                <td>
                  <table width="570" align="center" cellpadding="0" cellspacing="0" border="0" bgcolor="white">
                    <tr>
                      <td valign="top" align="left" width="90">
                        <font size="1" color="#77a087" face="Verdana">событие</font><br>
                        <img src="'+img+'" alt="">
                      </td>
                      <td>
                        <font size="3" color="#77a087" face="Verdana">'+title+'</font><br>
                        <font size="1" color="#77a087" face="Verdana">&nbsp;</font><br>                                                                                            
                        <font size="2" color="#77a087" face="Verdana">строк подачи резюме с '+ Russian::strftime(event.start_date, "%d %B") +' до '+ Russian::strftime(event.request_date, "%d %B") +'</font>
                        <font size="1" color="#77a087" face="Verdana">&nbsp;</font><br>
                        <font size="1" color="#77a087" face="Verdana">&nbsp;</font><br>
                      </td>
                      <td width="10" align="left"><img src="'+adress+'assets/separator.png" alt=""></td>
                      <td width="110" cellpadding="0"><font size="1" color="#77a087" face="Verdana">
                       '+event.start_date.strftime("%d/%m/%Y")+'<br>
                        '+nation+'<br>
                        '+event.start_date.strftime("%H:%M")+' - '+event.end_date.strftime("%H:%M")+'
                      </font></td>
                    </tr>
                  </table>    
                  <table width="570" align="center" cellpadding="0" cellspacing="0" border="0" bgcolor="white">
                    <tr>
                      <td rowspan="2" valign="top" align="left">
                        <a href="'+adress+'?event_id='+event.id.to_s+'"><font size="1" color="#77a087" face="Verdana">ПОДРОБНЕЕ ></font></a><br>
                        <a href="https://www.google.com/calendar"><font size="1" color="#77a087" face="Verdana">+ В GOOGLE КАЛЕНДАРЬ ></font></a>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <br>'
  
  return event_content
  end

end
