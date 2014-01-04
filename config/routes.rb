LecheAsada::Application.routes.draw do
  root 'static#home'

  match '/feed', to: 'static#feed', via: 'get'
end
