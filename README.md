Spree Epay Gateway
================

## Installation

1. Add this extension to your Gemfile with this line:
  ```ruby
  gem 'spree_epay_gateway', git: 'https://github.com/SValkanov/spree_epay_gateway', branch: '3-1-stable'
  ```

2. Install the gem using Bundler:
  ```ruby
  bundle install
  ```

3. Create initializer
  ```ruby
  bundle exec rails g spree_epay_gateway:install
  ```

  OR setup your /config/initializers/epay_gateway.rb file
  ```ruby
  config = Rails.application.config
  config.after_initialize do
    config.spree.payment_methods << Spree::Gateway::EpayBg
  end
  ```

4. Set URL address in your Spree configuration (http://localhost:3000/admin/general_settings/edit)

5. Restart your server

  If your server was running, restart it so that it can find the assets properly.


Copyright (c) 2017 Stanislav Valkanov, released under the New BSD License
