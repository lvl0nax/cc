class ImagesController < ApplicationController
  def create
    @image = Image.new(params[:grant][:u_image])
    @image.save
    render @image
  end
end
