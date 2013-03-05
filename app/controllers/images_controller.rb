class ImagesController < ApplicationController
  def create

    # Logic for grant image upload
    unless params[:grant].nil?

      if cookies[:grant_image].nil? # Cheking if we have image uploaded
        f = File.new("grant.rb","w")
        f.puts(params[:grant][:u_image])
        f.close
        @image = Image.new(params[:grant][:u_image]) # Creating new image

        if @image.save
          cookies[:grant_image] = {:value => @image.id, :expires => 1.hour.from_now} if cookies[:grant_image].nil?
          return render @image #If everything was OK - sending image to user

        end
      elsif not cookies[:grant_image].nil?
        @image = Image.find(cookies[:grant_image])
        @image.update_attributes(params[:grant][:u_image]) unless @image.nil?
        return render @image

      end
    end # We will get an exception if will not find image with such id



    # Logic for training image upload
    unless params[:training].nil?

      if cookies[:training_image].nil? # Cheking if we have image uploaded
        @image = Image.new(params[:training][:u_image]) # Creating new image

        if @image.save
          cookies[:training_image] = {:value => @image.id, :expires => 1.hour.from_now} if cookies[:training_image].nil?
          return render @image #If everything was OK - sending image to user

        end
      elsif not cookies[:training_image].nil?
        @image = Image.find(cookies[:training_image])
        @image.update_attributes(params[:training][:u_image]) unless @image.nil?
        return render @image

      end
    end # We will get an exception if will not find image with such id


    # Logic for event image upload
    unless params[:event].nil?

      if cookies[:event_image].nil? # Cheking if we have image uploaded
        @image = Image.new(params[:event][:u_image]) # Creating new image

        if @image.save
          cookies[:event_image] = {:value => @image.id, :expires => 1.hour.from_now} if cookies[:event_image].nil?
          return render @image #If everything was OK - sending image to user

        end
      elsif not cookies[:event_image].nil?
        @image = Image.find(cookies[:event_image])
        @image.update_attributes(params[:event][:u_image]) unless @image.nil?
        return render @image

      end
    end # We will get an exception if will not find image with such id


  end

end
