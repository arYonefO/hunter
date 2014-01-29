class StaticController < ApplicationController

  def home
  end

  def feed
    render json: Entry.prepare_for_launch
  end

  def d3
  end

end