## Setup Instructions For Mac

Install [`rvm`](https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/) or [`chruby`]( https://github.com/postmodern/chruby).
Then do:
```bash
  brew install mysql2
  ruby-install ruby 2.4.1
  rvm use ruby-2.4.1 (or chruby use ruby-2.4.1)
  gem install bundler
  bundle
  rake db:create
  rake db:migrate
```

## Start up Interactive Command Line App
```ruby
  $ rails c
  > Services::ManageGist.new.()
```

## Start up Web App
```bash
  rails s
```
# Grab all notes by a user
```bash
  rails s
```
