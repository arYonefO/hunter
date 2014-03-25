LecheAsada::Application.routes.draw do
  root 'static#home'

  match '/feed/:lng', to: 'static#feed', via: 'get'
  match 'about', to: 'static#about', via: 'get'
  match 'search_term', to: 'search_term#create', via: 'post'

  # Playpen
  match '/d3', to: 'static#d3', via: 'get'
end
