class Application
 
  def initialize
    # Start with an empty array of contacts.
    # TODO: Perhaps stub (seed) some contacts so we don't have to create some every time we restart the app
    @contacts = []
    contact1 = Contact.new("Abid Velshi", "abid.velshi@gmail.com", {"Home" => 14168271871})
    @contacts << contact1
    
    @phone_number_hash = {}

    @exit_cmd = 'exit'
    @new_cmd = 'new'
    @list_cmd = 'list'
    @edit_name_cmd = 'edit name'
    @edit_phone_cmd = 'edit phone'
    @edit_email_cmd = 'edit email'
    @back_cmd = 'back'
    @phone_cmd = 'phone'

  end
 
  def run
    begin 
        show_main_menu
        input = gets.chomp
        if (input.start_with?"show")
          show_cmd = input
        end

        case input
          when (@new_cmd)
            create_new_card(@new_cmd)

          when (@list_cmd)
            list_cards
          
          when (show_cmd)
            show_card(show_cmd)
            puts "You are now in edit mode"
            begin
              edit_mode = gets.chomp
              if (edit_mode == @edit_name_cmd)
                edit_name(show_cmd)
              elsif (edit_mode == @edit_email_cmd)
                edit_email(show_cmd)
              else
                puts 'Please enter a valid command'
              end
            end while (edit_mode != @back_cmd)
        end      
    end while (input != @exit_cmd)
  end
  
  # Prints the main menu only
  def show_main_menu
    puts "Welcome to the app. What's next?"
    puts " new      - Create a new contact"
    puts " list     - List all contacts"
    puts " show :id - Display contact details"
    print "> "
  end

  # Creates a new card
  def create_new_card(new_command)
    puts "Enter a first and last name"
    full_name = gets.chomp
    puts "Enter an email address"
    email_address = gets.chomp
    puts "Would you like to add a phone number"
    user_response_phone = gets.chomp
    if (user_response_phone == 'yes')
      add_phone_number
    end

    # check if there is an existing card
    existing_contact = @contacts.detect {|c| c.email == email_address }
    if existing_contact
      puts "Contact already exists!"
      return  
    end

    # create card
    new_card = Contact.new(full_name, email_address, @phone_number_hash)
    @contacts << new_card
    # Clear phone number hash
    @phone_number_hash = {}
    puts 'Contact ' + new_card.to_s + ' created.'
  end

  def list_cards
    @contacts.each_with_index { |val, index| puts "#{index}: " + "#{@contacts[index]}"}
  end

  def show_card(show_command)
    card_index = (show_command.split(' '))[1]
      if (@contacts[card_index.to_i] == nil)
        puts "The card does not exist!"
      else
        puts "#{card_index}: " + "#{@contacts[card_index.to_i]}"
      end
  end

  def edit_name(show_command)
    card_index = (show_command.split(' '))[1]
    puts 'Please enter the new name'
    new_name = gets.chomp
    @contacts[card_index.to_i].edit_contact_name(new_name)
    puts "New record: #{@contacts[card_index.to_i]}:"
  end

  def edit_email(show_command)
    card_index = (show_command.split(' '))[1]
    puts 'Please enter the new email address'
    new_email = gets.chomp
    @contacts[card_index.to_i].edit_contact_email(new_email)
    puts "New record: #{@contacts[card_index.to_i]}:"
  end

  def add_phone_number
    begin
      puts "Enter a phone number location"
      phone_number_location = gets.chomp
      puts "Enter a phone number (digits only)"
      phone_number = gets.chomp
      @phone_number_hash[phone_number_location] = phone_number
      puts "Would you like to enter another?"
      user_response_phone = gets.chomp
    end while (user_response_phone != 'no')
  end
 
end
