class Application
 
  def initialize
    # Start with an empty array of contacts.
    # TODO: Perhaps stub (seed) some contacts so we don't have to create some every time we restart the app
    @contacts = []
    contact1 = Contact.new("Abid Velshi", "abid.velshi@gmail.com")
    @contacts << contact1
    
    @exit_cmd = 'exit'
    @new_cmd = 'new'
    @list_cmd = 'list'
    @edit_name_cmd = 'edit name'
    @edit_phone_cmd = 'edit phone'
    @back_cmd = 'back'

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
            input = gets.chomp
            begin
              edit_card
            end while (input != @back_cmd)
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

    # check if there is an existing card
    existing_contact = @contacts.detect {|c| c.email == email_address }
    if existing_contact
      puts "Contact already exists!"
      return  
    end

    # create card
    new_card = Contact.new(full_name, email_address)
    @contacts << new_card
    puts 'Contact ' + new_card.to_s + ' created.'
  end

  def list_cards
    @contacts.each_with_index { |val, index| puts "#{index}: " + "#{@contacts[index]}"}
  end

  def show_card(show_command)
    puts "Remember, the index starts at 0!"
    card_index = (show_command.split(' '))[1]
      if (@contacts[card_index.to_i] == nil)
        puts "The card does not exist!"
      else
        puts "#{card_index}: " + "#{@contacts[card_index.to_i]}"
      end
  end

  def edit_card
    puts "edit!"
  end
 
end
