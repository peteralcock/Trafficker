Dummy::Application.routes.draw do
  mount Slammer::Engine => '/', :as => 'slammer'
end
