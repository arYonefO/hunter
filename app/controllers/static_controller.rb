class StaticController < ApplicationController

  def home
    @images = Entry.random_images(2)
  end

  def feed
    render json: Entry.prepare_for_launch(params[:lng])
  end

  def about
    @images = Entry.random_images(4)
  end

  def d3
  end

end