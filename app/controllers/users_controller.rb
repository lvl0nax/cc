# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def show
    @title = "Информация о компании"
    @user = current_user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resume }
    end

  end

  def sphere

  end

  def activities

    @years = %w[2012 2013]
    @months =  %w[январь февраль март апрель май июнь июль август сентябрь октябрь ноябрь декабрь]

    #logger.debug "--------------------------------------------"
    @user = User.find(params[:id])
    @actions = @user.actions
    #logger.debug @actions
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @actions }
    end
  end

  def userevents
    @user = User.find(params[:id])
    @userevents = UserEvent.where(:user_id => @user.id)
    @action_events = []
    @userevents.each do |ue|
      @action_events += EventParent.where(:id => ue.event_parent_id, :status => 'ОДОБРЕНО').to_a
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evnts }
    end
  end

  def admin_page
    authorize! :admin_page, User
    @count = EventParent.any_in(:status => [nil, "УДАЛЕНО", "НОВОЕ"]).count
  end

  def update
    @user = User.find(params[:id])    

    if @user.valid_password?(params[:user][:current_password])
      if @user.update_attributes(params[:user])
        @message = 'Пароль изменен'
        sign_in('user', @user)
      else
        @message = 'Error'
      end
    else
      @message = 'Старый пароль не совпадает'
    end

  end

  def valid
    role = params[:user][:role][:name]
      #з фото
    if role == 'employer'
      if not params[:user][:compinfo].nil? and params[:user][:compinfo][:photo] and not cookies[:with_photo]
        # puts 'x0'
        user = User.new(params[:user])
        compinfo = Compinfo.new(params[:user][:compinfo])
        user.compinfo = compinfo
        compinfo.save!
        user.save(:validate=>false)
        cookies[:with_photo] = user._id

        return render :json => {:url => compinfo.photo.url}
        #якщо змінив картинку
      elsif params[:user][:compinfo][:photo] and cookies[:with_photo]
        # puts 'x1'
        user = User.find(cookies[:with_photo])
        compinfo = Compinfo.new(params[:user][:compinfo])
        user.compinfo = compinfo
        compinfo.save!
        user.save(:validate=>false)
        return render :json => {:url => compinfo.photo.url}
        #поставив картинку і перезагрузив сторінку
      elsif not params[:user][:compinfo][:photo] and cookies[:with_photo] and not params[:user]
        # puts 'x2'
        cookies[:delete_user] = cookies[:with_photo]
        cookies.delete :with_photo
      end
    end


    if role == "employer" or role == "employee"
      temp = User.count
         #пошук юзера з картинкою
     if not cookies[:with_photo].nil?
       # puts 'x3'
        @user = User.find(cookies[:with_photo]) if role =='employer'
       #загрузив фотку і вирішив створити МС
        if role == 'employee'
          user_delete =  User.find(cookies[:with_photo])
          user_delete.destroy
          cookies.delete :with_photo
        end
        #перезагрузив під-час реєстрації(видалення непотрібного юзера)
     elsif not cookies[:delete_user].nil?
       # puts 'x4'
          user_delete =  User.find(cookies[:delete_user])
          user_delete.destroy
          cookies.delete :delete_user
      end
      #user without photo
      if cookies[:delete_user].nil? and cookies[:with_photo].nil?
        # puts 'x5'
        @user = User.new(params[:user])
      end
       @user.compinfo(:validate=>false) if role == "employer"
      if @user.save
        # UserMailer.register(@user).deliver
        # puts 'x6'
        if temp == 0
          @user.role = Role.new(:name => "admin")
          @user.resume = Resume.new(params[:user][:resume])
        else
          @user.role = Role.new(:name => role)
          @user.resume = Resume.new(params[:user][:resume]) if role == "employee"
          @user.compinfo = Compinfo.new(params[:user][:compinfo]) if role == "employer"
          cookies.delete :with_photo
          @user.resume.save
        end

        flash[:register] = true

        sign_in('user', @user)        
        path = edit_compinfo_path(@user.compinfo) if role == "employer"
        path = edit_resume_path(@user.resume) if role == "employee"

        render json:{ success:true, path:path }
      else
        if  @user.errors.count > 0 and not cookies[:with_photo]
          # puts 'x7'
          return render json: @user.errors
        elsif not cookies[:with_photo].nil? and @user.errors.count > 0
          # puts 'x8'
          if @user.update_attributes(params[:user])
            # puts 'x9'
            @user.role = Role.new(:name => role)
            sign_in('user', @user)
            path = edit_compinfo_path(@user.compinfo)
            cookies.delete :with_photo
            
            return render :json => { :url => @user.compinfo.photo.url, success:true, path:path }
          else
            # puts 'x10'
            return render json: @user.errors
          end
        end
      end

    else
      raise "ERROR! incorrect user params!"
   end
  end

  def add_remove_event
    @user = User.find(current_user.id)
    if params[:str].eql?('add')
      @user_event = UserEvent.create(user_id: @user.id, event_parent_id: params[:id_event])
    elsif params[:str].eql?('remove')
      @ue = UserEvent.where(:user_id => current_user.id, :event_parent_id => params[:id_event])
      @ue.destroy
    end
    render :text => ''
  end

  def created_event
    @items = EventParent.where(:owner => current_user.id)
    
    @items.each do |item|
      item.visible = true
    end

    @user = current_user
  end

  def send_mails
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
    end

    puts 'XXXXX'*5
    puts @user_list.count
    redirect_to '/admin_page'
  end

  def return_mail_content(name, event_list)
    @content = '<!DOCTYPE HTML>
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
          <img style="width:100%" src="/assets/header.png" alt="">
          </td>
          </tr>
          <tr>
          <td>
          <table style="width:650px; margin:0 auto;">
          <tr>
          <td>
          <span style="text-transform:uppercase; font-size:18px; padding: 30px 0 25px 0px; color:#354242; float:left;">Уважаемый, <span style="color:#77a087;">'+name+'!</span></span><img  style="float:right; padding-top:20px; margin-right:20px; margin-bottom:20px;" src="/assets/logo.png" alt="">
          <span style="display:block; clear:both;"></span>
          <p style=" font-family: tahoma;  font-size:14px; padding: 0px 0 15px 0px; color:#354242;">Предлагаем Вам ознакомится с самыми интересными карьерными и професиональными мероприятиями, подобраными в соответствии с Вашыми интересами. Пополнить список интересующих Вас сфер можно в <a href="'+root_path+'" style="font:tahoma 25px; color:#77a087;">личном кабинте </a></p>
          </td>
          </tr>
          <tr>
          <td>
          <table>'+
            event_list.each_with_index do |index, event|
              if event._type == 'Grand'
                content_grant(event)
              elsif event._type == 'Event'
                content_event(event)
              elsif event._type == 'Training'
                content_training(event)
              end                  
              if index == 4
                break
              end
            end
              +'          
          </table>
          </td>
          </tr>
          <tr>
          <td style="text-transform:uppercase; font-size:14px; padding: 13px 0 13px 30px;  color:#354242;">
          <span style="float:left">желаем успеха, ваш центр карьеры</span>
          <a href="'+root_path+'" style="font:tahoma 13px; color:#77a087; float:right; text-transform:none; margin-right:20px">centercareeer.ru </a>
          </td>
          </tr>
          </table>
          </td>
          </tr>
          <tr>
          <td>
          <img style="width:100%" src="/assets/footer.png" alt="">
          </td>
          </tr>
          </table>
          </body>
          </html>'
    return @content
  end

  def content_grant(grant)
    grant_content = '<tr><td><table style="width:630px; border-left:10px solid #354242; border-right:10px solid #354242; border-top:1px solid #354242; border-bottom:1px solid #354242; background-color:white; margin-bottom:4px;">
    <tr>
      <td style="padding:15px 25px 5px 25px;">
        <span style="font-family:verdana; font-size:10px; color:#354242; float:left;">грант<br/>
          <img src="'+ Image.find(grant.image_id).photo.thumb unless grant.image_id.eql?('') else +'/assets/contimg4.png" alt="">
        </span>
        <h3 style="font-family:verdana; font-size:18px; color:#354242; font-weight:normal; margin-left:80px;">'+grant.title+'</h3>
        <p style="font-family:verdana; font-size:12px; color:#354242; font-weight:normal; margin-left:80px;">подача тезисов '+ grant.start_date.strftime("%d %m %Y") +'//<br> с 09:00 до '+ grant.start_date.strftime(" %H:%M ") +'</p>
        <span style="display:block; clear:both;"></span>
        <a href="'+root_path+'" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#354242; font-weight:normal; margin-top:15px; display:block;">Подробнее ></a>
        <a href="https://www.google.com/calendar" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#354242; font-weight:normal; margin-top:5px; display:block;">+ в Google календарь</a>
        <span style="display:block; text-align:left; font-size: 10px; color: #354242; width:110px;">
          <br>
          '+ grant.start_date.strftime("%d %B %Y") +' <br>
          '+ grant.nation if grant.nation +'<br>
          09:00 - '+ grant.start_date.strftime(" %H:%M ") +'
        </span>
      </td>
    </tr>
  </table></td></tr>'
  end

  def content_event(event)
    event_content = '<tr><td><table style="width:630px; border-left:10px solid #77a087; border-right:10px solid #77a087; border-top:1px solid #77a087; border-bottom:1px solid #77a087; background-color:white; margin-bottom:4px;">
    <tr>
      <td style="padding:15px 25px 5px 25px;">
        <span style="font-family:verdana; font-size:10px; color:#77a087; float:left;">событие<br/>
         <img src="'+ Image.find(event.image_id).photo.thumb unless event.image_id.eql?('') else +'/assets/contimg5.png" alt="">
        </span>
        <h3 style="font-family:verdana; font-size:18px; color:#77a087; font-weight:normal; margin-left:80px;">'+event.title+'</h3>
        <p style="font-family:verdana; font-size:12px; color:#77a087; font-weight:normal; margin-left:80px;">строк подачи резюме с '+ event.start_date.strftime("%d %m") +' до '+ event.request_date.strftime("%d %m") +'</p>
        <span style="display:block; clear:both;"></span>
        <a href="'+root_path+'" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#77a087; font-weight:normal; margin-top:15px; display:block;">Подробнее ></a>
        <a href="https://www.google.com/calendar" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:#77a087; font-weight:normal; margin-top:5px; display:block;">+ в Google календарь</a>
        <span style="display:block; text-align:left; font-size: 10px; color: #77A087; width:110px;">
          <br>
          '+ event.start_date.strftime("%d/%m/%Y") +'<br>
          '+ event.nation if event.nation +'<br>
          '+ event.start_date.strftime("%H:%M") +' - '+ event.end_date.strftime("%H:%M") +'
        </span>
      </td>
    </tr>
  </table></tr></td>'
  end

  def content_training(train)
    train_content = '<tr><td><table style="width:630px; border-left:10px solid white; border-right:10px solid white; background-color:#c5d757; margin-bottom:4px;">
    <tr>
      <td style="padding:15px 25px 5px 25px">
        <span style="font-family:verdana; font-size:10px; color:white; float:left;">стажировка<br/>
          <img src="'+ Image.find(train.image_id).photo.thumb unless train.image_id.eql?('') else +'/assets/contimg6.png" alt="">
        </span>
        <h3 style="font-family:verdana; font-size:18px; color:white; font-weight:normal; margin-left:80px;">'+train.title+'</h3>
        <p style="font-family:verdana; font-size:12px; color:white; font-weight:normal; margin-left:80px;">строк подачи резюме с '+ train.start_date.strftime("%d %m") +' до '+ train.request_date.strftime("%d %m") +'</p>
        <span style="display:block; clear:both;"></span>
        <a href="'+root_path+'" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:white; font-weight:normal; margin-top:15px; display:block;">Подробнее ></a>
        <a href="https://www.google.com/calendar" style="text-transform:uppercase;font-family:verdana; font-size:10px; color:white; font-weight:normal; margin-top:30px; display:block;">+ в Google календарь</a>
        <span style="display:block; text-align:left; font-size: 10px; color: white; width:110px;">
          <br>
          '+ train.start_date.strftime("%d/%m/%Y") +'<br>
          '+ train.nation if train.nation +'<br>
          '+ train.start_date.strftime("%H:%M") +' - '+ train.end_date.strftime("%H:%M") +'
        </span>
      </td>
    </tr>
  </table></tr></td>'
  end

end