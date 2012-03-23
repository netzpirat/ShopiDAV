require 'sidekiq/web'

Shopidav::Application.routes.draw do

  constraints :subdomain => 'www' do
    mount Sidekiq::Web => '/admin/sidekiq'

    match 'login'              => 'login#index',        :as => :login
    match 'login/authenticate' => 'login#authenticate', :as => :authenticate
    match 'login/finalize'     => 'login#finalize',     :as => :finalize
    match 'login/logout'       => 'login#logout',       :as => :logout

    root :to                   => 'home#index'
  end

  constraints :subdomain => /^((?!www).)+$/ do
    mount DAV4Rack::Handler.new({
      :root => '',
      :root_uri_path => '/',
      :resource_class => ::Shopidav::Resource
    }), :at => '/'
  end

  root to: redirect('http://www.lvh.me:3000')
end
