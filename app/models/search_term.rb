class SearchTerm < ActiveRecord::Base
  validates :search_term, presence: true, uniqueness: true

  def self.update_or_create_search_term(params)
    p params[:lat]
    # find_or_create using search_term
    current_search_term = SearchTerm.find_by(search_term: params[:search_term])
    time = Time.now.to_s
    if current_search_term
      current_search_term.count += 1
      current_search_term.when.push(time)
      current_search_term.when_will_change!
      current_search_term.save
    else
      SearchTerm.create(
                        'search_term' => params[:search_term],
                        'when' => [time],
                        'count' => 1,
                        'lat' => params[:lat],
                        'lng' => params[:lng]
                        )
    end
  end
end