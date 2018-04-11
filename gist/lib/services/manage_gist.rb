module Services
  class ManageGist
    attr_reader :logged_in_user

    def call
      puts "Welcome! Here's a program where you can interact with blobs of writing."
      options_menu
    end

    private

    def parse_command(input)
      args = input.split
      case args[0].downcase.gsub(/[^a-z]/i, '')
      when 'menu', 'help', 'h'
        options_menu
      when 'quit', 'q'
        puts "Exiting..."
      when 'login', 'in'
        login(args[1], args[2])
      when 'list', 'l'
        list_notes
      when 'create', 'i'
        create_note(input.remove(input[/(\S+)/, 1]).strip)
      when 'signup', 'up'
        signup(args[1])
      when 'delete', 'd'
        delete_note(args[1])
      when 'logout', 'out'
        logout
      else
        notify_with_message(action: :failure)
      end
    end

    def options_menu
      puts "Usage:"
      puts "      create [Text]             creates a new post"
      puts "      delete [ID]               deletes the post with [ID]"
      puts "      list                      shows you all your posts with recently created first"
      puts "      login [Email] [Token]     logs you in"
      puts "      logout                    logs you out"
      puts "      menu                      lists all commands you can run"
      puts "      signup [Email]            signs you up"
      puts "      quit                      exits the program"
      request_input
    end

    # TODO: Do not pass around database ids to the user.  Have a friendly string and one not related to the database
    # record in the future to make it easier for the user and less risky of a transaction
    # @param [ID] id of a NoteRecord
    def delete_note(id)
      notify_login_neeeded unless logged_in_user.present?

      # If it's already soft-deleted and we soft-delete it again, that is okay from the user's perspective.  But if
      # the record never existed, we should tell the user that.
      record = NoteRecord.unscoped.find_by_id(id)
      notify_with_message(text: "No post exists with id: #{id}") unless record.present?

      unless (record.person_record == logged_in_user)
        notify_with_message(text: "You do not have permission to delete this post")
      end

      action = record.soft_delete ? :success : :failure
      notify_with_message(action: (record.soft_delete ? :success : :failure))
    end

    def list_notes
      notify_login_neeeded unless logged_in_user.present?
      notes = NoteRecord.by_person_records(logged_in_user).sort_by(&:updated_at)

      if notes.empty?
        return notify_with_message(text: "You have no posts. Use the `create` command to create one.")
      end

      notes.each do |post|
        puts "Last updated at: #{post.updated_at}"
        puts "Identifier: #{post.id}"
        puts "#{post.text}"
        puts ""
      end

      request_input
    end

    def create_note(text)
      notify_login_neeeded unless logged_in_user.present?

      notify_with_message(text: "Post can not be blank") unless text.present?

      # This commit_token needs to be created on the client and passed in so it's useless but this is for practice!
      commit_token = (0...15).map { (65 + rand(26)).chr }.join
      record = NoteRecord.create(person_record: logged_in_user, text: text, commit_token: commit_token)

      is_success = record.valid? || (record.errors.messages[:commit_token].try(:first) == 'indicates request went through.')
      notify_with_message(action: (is_success ? :success : :failure))
    end

    def login(email, token)
      notify_logout_neeeded if logged_in_user.present?
      record = PersonRecord.find_by_email(email)
      notify_with_message(text: "No user exists with that email. Kindly try again") unless record.present?
      notify_with_message(text: "The email and token combination do not exist in our sytem.  Kindly try again.") unless (record.token == token)

      @logged_in_user = record
      notify_with_message(action: :success)
    end

    def logout
      notify_login_neeeded unless logged_in_user.present?
      @logged_in_user = nil
      notify_with_message(action: :success)
    end

    def signup(email)
      notify_logout_neeeded if logged_in_user.present?

      # This commit_token needs to be created on the client and passed in so it's useless but this is for practice!
      commit_token = (0...15).map { (65 + rand(26)).chr }.join
      record = PersonRecord.create(email: email, commit_token: commit_token)

      if record.valid? || (record.errors.messages[:commit_token].try(:first) == 'indicates request went through.')
        notify_with_message(text: "SUCCESS! We created a user for you with email: #{record.email} and token: #{record.token}")
      else
        notify_with_message(text: record.errors.full_messages)
      end
    end

    def request_input
      print "#{@logged_in_user.try(:email)}> "
      parse_command(gets)
    end

    # @param [Symbol] action is an optional param that can be set to :success or :failure
    # @param [String] text is an optional param that would be displayed to the user to notify them about what
    # happened
    def notify_with_message(action: nil, text: nil)
      if text.present?
        puts text
      elsif action == :success
        puts 'SUCCESSS!'
      elsif action == :failure
        puts "Sorry we couldn't parse your statement. Kindly try again."
      end

      request_input
    end

    def notify_login_neeeded
      text = "This action requires you to be logged in. Use the command `login` and try again"
      notify_with_message(text: text)
    end

    def notify_logout_neeeded
      notify_with_message(text: "This action requires you to be logged out. Use the command `logout` and try again")
    end
  end
end
