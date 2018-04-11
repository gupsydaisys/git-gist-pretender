# Setup Instructions For Mac
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

# Interactive "Command Line" App
```ruby
  $ rails c
  > Services::ManageGist.new.()
```

# HTTP Endpoints
```bash
  rails s
```
## Grab all notes by a user aka `list`
```javascript
  curl -i http://localhost:3000/note_records?id=USER_ID
  curl -i http://localhost:3000/note_records?email=USER_EMAIL
```
