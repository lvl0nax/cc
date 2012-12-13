class ImagesController < ApplicationController
  def create
    @image = Image.new(params[:grant][:image])
    render @image
  end
end
