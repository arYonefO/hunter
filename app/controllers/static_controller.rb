class StaticController < ApplicationController

  def home
    @images = Entry.two_random_images
  end

  def feed
    render json: Entry.prepare_for_launch
  end

  def d3
  end

end