class StaticController < ApplicationController

  def home
  end

  def feed
    render json: Entry.where("prox >= ?", 5).to_json
  end

end