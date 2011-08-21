ActionController::Routing::Routes.draw do |map|
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :versions, :member => { :diff => :get, :summary => :get }
  end
end
