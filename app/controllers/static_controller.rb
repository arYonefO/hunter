class StaticController < ApplicationController

  def home
    @images = Entry.random_images(2)
  end

  def feed
    render json: Entry.prepare_for_launch(params[:lat], params[:lng])
  end

  def about
    @images = Entry.random_images(4)
  end

  def d3
  end

  def leaflet
    @images = Entry.random_images(2)
  end

end