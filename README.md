In database.yml, change the username and pwd accordingly and create a db scraping in your mysql login 
Go to terminal
rvm use ruby 2.6
gem install bundler
rake db:migrate
rails c 
ApiScraperController.new.scraper
