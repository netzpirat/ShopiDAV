source 'https://rubygems.org'

gem 'rails', '3.2.2'

gem 'pg'
gem 'jquery-rails'
gem 'shopify_app'
gem 'dav4rack', :git => 'git://github.com/chrisroberts/dav4rack.git'
gem 'haml'
gem 'mime-types'
gem 'sidekiq'
gem 'slim'
gem 'sinatra'
gem 'airbrake'
gem 'yajl-ruby'

group :assets do
  gem 'twitter-bootstrap-rails'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'guard'              , :require => false, :path => '/Users/michi/Repositories/guard'
  gem 'guard-coffeescript' , :require => false, :path => '/Users/michi/Repositories/guard-coffeescript'
  gem 'guard-rspec'        , :require => false
  gem 'guard-livereload'   , :require => false
  gem 'pry'                , :require => false
  gem 'pry-doc'            , :require => false
  gem 'rb-fsevent'         , :require => false
  gem 'rake'               , :require => false
  gem 'growl'              , :require => false
  gem 'yard'               , :require => false
  gem 'foreman'            , :require => false
end

group :test, :development do
  gem 'fabrication'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'thin'
end
