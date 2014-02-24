LecheAsada::Application.routes.draw do
  root 'static#home'

  match '/feed/:lng', to: 'static#feed', via: 'get'
  match 'about', to: 'static#about', via: 'get'

  # Playpen
  match '/d3', to: 'static#d3', via: 'get'
end
