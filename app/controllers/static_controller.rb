class StaticController < ApplicationController

  def home
  end

  def feed
    render json: Entry.all.to_json
  end

end