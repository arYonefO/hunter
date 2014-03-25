class SearchTermController < ApplicationController
  def create
    SearchTerm.update_or_create_search_term(params[:search_term])
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end