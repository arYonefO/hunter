LecheAsada::Application.routes.draw do
  root 'static#home'

  match '/feed', to: 'static#feed', via: 'get'
  match '/d3', to: 'static#d3', via: 'get'
end
