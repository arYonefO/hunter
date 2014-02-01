class StaticController < ApplicationController

  def home
    @images = []
    5.times do
      find_image = rand(60000)
      if Entry.find_by(id: find_image)
        @images << Entry.find_by(id: find_image).full_image_url
      end
    end
  end

  def feed
    render json: Entry.prepare_for_launch
  end

  def d3
  end

end