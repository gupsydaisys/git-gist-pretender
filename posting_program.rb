#######################################################
#######################################################
####################### MODELS ########################
#######################################################
#######################################################

####################### USER ########################
# SUDO database model of a USER (id, email, token) w/ key id
USER_TABLE = {} # map of email to (email, token)

# SEPERATE EMAIL VALIDATION
USER_VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

def create_user(email)
  return { errors: { email: 'is not present' } } if email.empty?
  return { errors: { email: 'is not a valid format' } } unless USER_VALID_EMAIL_REGEX.match(email)
  return { errors: { email: 'is taken' }} if USER_TABLE.keys.include?(email)

  USER_TABLE[email] = { email: email, token: Random.rand(100000000000000) }
  return USER_TABLE[email]
end

####################### POST ########################
# SUDO database model of a POST (id, text, user_id, updated_at) w/ key id
# TODO add deleted_at and updated_at timestamps
POST_TABLE = {} # map of id to (text, user_email, created_at) (since user_email == user_id)
POST_FOR_USER_TABLE = {} # map of user_email to an array of post id to make my life easier
$post_id_tracker = 0 # id counter for sudo database

def create_post(text, user_email)
  errors = {}
  errors[:user_email] = 'is not provided' if user_email.empty?
  errors[:text] = 'can not be blank' unless text
  return errors unless errors.empty?

  POST_TABLE[$post_id_tracker] = { id: $post_id_tracker, text: text, user_email: user_email, created_at: Time.now }
  POST_FOR_USER_TABLE[user_email] = (POST_FOR_USER_TABLE[user_email] || []) << POST_TABLE[$post_id_tracker]
  $post_id_tracker = $post_id_tracker + 1
  return POST_TABLE[$post_id_tracker - 1]
end

def list_posts(user_email)
  POST_FOR_USER_TABLE[user_email].reverse # TODO sort by created at
end

#######################################################
#######################################################
############### MUTATIONS & QUERIES (CONTROLLER) ######
#######################################################
#######################################################
def sign_up(email)
  unless $logged_in_user.empty?
    display_failure("Please log out before signing up a new user")
  end

  user = create_user(email)

  if user[:errors]
    display_failure # TODO put together key + value to get error for user so it's more readable
  else
    $logged_in_user = user[:email]
    display_success("SUCCESS! We created an account for you with token: #{user[:token]}")
  end
end

# TODO rename this method
def create(text)
  post = create_post(text, $logged_in_user)

  if post[:errors]
    display_failure # TODO put together errors from hash returned
  else
    display_success("SUCCESS! We created a new post for you with id: #{post[:id]}")
  end
end

# Decided not to implement allowing the user to grab the first or last N number of posts with recently created at first
# since the feature just isn't valuable yet.
# TODO implement limit so that the user can't do something stupid + rename method
def list
  if $logged_in_user.empty?
    display_failure("Please log in or sign up before querying for a list of posts (none will show currently).")
  end

  response = list_posts($logged_in_user)

  return display_success("You have no posts. Use the `create` command to make one.") if response.empty?

  response.each do |post|
    puts "Updated At: #{post[:created_at]}"
    puts "#{post[:text]}"
    puts ""
  end

  request_input
end

# TODO implement an optional options array which tells you which commands to show or to only show implemented commands
def options_menu
  puts "Usage:"
  puts "      create <Text>           - creates a new post with <Text>"
  puts "      delete <Post ID>        - deletes a post with <Post Id>                         (NOT IMPLEMENTED"
  puts "      edit <Post ID>          - creates a new post with <Text>                        (NOT IMPLEMENTED"
  puts "      help                    - lists all commands you can run"
  puts "      list                    - shows you all your posts with recently created first"
  puts "      log-in <Email> <Token>  - logs you in                                           (NOT IMPLEMENTED)"
  puts "      log-out                 - logs you out                                          (NOT IMPLEMENTED)"
  puts "      sign-up <Email>         - signs you up with that email"
  request_input
end

######################################################
####### INPUT/OUTPUT PROCCESSING ######################
#######################################################
#######################################################
$logged_in_user = ''

def parse_command(command)
  args = command.split

  case args[0] # TODO take awhile all non alphabetical characters and make lower case to reduce user input errors
  when 'list'
    list
  when 'help'
    options_menu
  when 'sign-up'
    display_failure unless args[1]
    sign_up(args[1])
  when 'create'
    text = command[7..-1] # TODO Use a keyword instead of enter to deliminate when the user is done entering their text
    display_failure unless text
    create(text)
  else
    display_failure
  end
end

#######################################################
#######################################################
################# HELPERS #############################
#######################################################
#######################################################

def display_welcome
  puts "Welcome! Here's a program where you can interact with blobs of writing."
end

def display_success(message=nil)
  puts message if message
  request_input
end

def display_failure(error="Sorry we couldn't parse your statement. Kindly try again.")
  puts error
  request_input
end

def request_input
  print "#{$logged_in_user}> "
  parse_command(gets)
end

#######################################################
#######################################################
################# START PROGRAM #######################
#######################################################
#######################################################
display_welcome
options_menu
