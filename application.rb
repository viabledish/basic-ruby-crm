class Application
 
  def initialize

    @exit_cmd = 'exit'
    @new_cmd = 'new'
    @list_cmd = 'list'
    @list_most_cmd = 'list important'
    @edit_name_cmd = 'edit name'
    @add_phone_cmd = 'add phone'
    @edit_email_cmd = 'edit email'
    @edit_important_cmd = 'edit importance'
    @back_cmd = 'back'
    @phone_cmd = 'phone'

  end
 
  def run
    begin 
        show_main_menu
        input = gets.chomp
        if (input.start_with?"show")
          show_cmd = input
        elsif (input.start_with?"delete")
          delete_cmd = input
        elsif (input.start_with?"find")
          find_cmd = input
        end 

        case input
          when (@new_cmd)
            create_new_card(@new_cmd)

          when (@list_cmd)
            list_cards

          when (@list_most_cmd)
            list_most_important

          when (delete_cmd)
            delete_card(delete_cmd)

          when (find_cmd)
            find_contact(find_cmd)
          
          when (show_cmd)
            show_card(show_cmd)
            show_edit_menu
            begin
              edit_mode = gets.chomp
              if (edit_mode == @edit_name_cmd)
                edit_name(show_cmd)
              elsif (edit_mode == @edit_email_cmd)
                edit_email(show_cmd)
              elsif (edit_mode == @add_phone_cmd)
                card_index = (show_cmd.split(' '))[1]
                add_phone_number_to_record(card_index)
              elsif (edit_mode == @edit_important_cmd)
                edit_importance(show_cmd)
                
              else
                puts 'Please enter a valid command'
              end
            end while (edit_mode != @back_cmd)
        end      
    end while (input != @exit_cmd)
  end
  
  # Prints the main menu only
  def show_main_menu
    puts " Welcome to the app. What's next?"
    puts " new                - Create a new contact"
    puts " list               - List all contacts"
    puts " list important     - List all contacts"
    puts " show :id           - Display contact details"
    puts " delete             - Delete an entry"
    puts " find               - Find an entry"
    print "> "
  end

  # Prints the edit menu only
  def show_edit_menu
    puts " You are now in edit mode"
    puts " edit name       - edit the name of this contact"
    puts " edit email      - edit the email of this contact"
    puts " add phone       - add a phone number to this contact"
    puts " edit importance - edit the importance of this contact"
    print "> "
  end

  # Creates a new card
  def create_new_card(new_command)
    puts "What importance do you want to give this contact (1 - 5)"
    importance_rating = gets.chomp
    puts "Enter a first and last name"
    full_name = gets.chomp
    puts "Enter an email address"
    email_address = gets.chomp
    puts "Would you like to add a phone number"
    user_response_phone = gets.chomp
    if (user_response_phone == 'yes')
      phone_number_string = add_phone_number
    end

    # check if there is an existing card
    # existing_contact = Contact.all.each.detect {|c| c.email == email_address }
    # if existing_contact
    #   puts "Contact already exists!"
    #   return  
    # end

    # Split first name, last name
    f_name, l_name = full_name.split 

    # Add card to ActiveRecord
    new_card = Contact.new(first_name: f_name, last_name: l_name, email: email_address, phone: phone_number_string, importance: importance_rating)
    if (new_card.save == true)
      puts "Contact " + new_card.id.to_s + ": " + new_card.first_name + ' ' + new_card.last_name + ' ' + new_card.email + ' ' + new_card.phone.to_s + ' created.'
    else
      new_card.errors.each do |error|
        puts error.to_s
      end
    end
  end

  def list_cards
    contact_list = Contact.all
    puts contact_list.inspect
  end

  def show_card(show_command)
    card_index = (show_command.split(' '))[1]
      if (Contact.find_by(id: card_index) == nil)
        puts "The card does not exist!"
      else
        card = Contact.find_by(id: card_index)
        puts "#{card_index}: " + "#{card.first_name} #{card.last_name}"
      end
  end

  def delete_card(delete_command)
    card_index = (delete_command.split(' '))[1]
      if (Contact.find_by(id: card_index) == nil)
        puts "The card does not exist!"
      else
        card = Contact.find_by(id: card_index)
        card.destroy
        puts "Record 3 no longer exists!"
      end
  end

  def edit_name(show_command)
    card_index = (show_command.split(' '))[1]
    puts 'Please enter the new name'
    new_name = gets.chomp
    card = Contact.find_by(id: card_index)
    f_name, l_name = new_name.split
    card.first_name = f_name
    card.last_name = l_name
    card.save
    puts "Updated record: #{card.id}: #{card.first_name} #{card.last_name}"
  end

  def edit_email(show_command)
    #Find alternate solution here
    card_index = (show_command.split(' '))[1]
    puts 'Please enter the new email address'
    new_email = gets.chomp
    card = Contact.find_by(id: card_index)
    card.email = new_email
    if (card.save == true)
      puts "Updated record: #{card.id}: #{card.email}"
    else
      puts "Email exists!"
    end
  end

  def edit_importance(show_command)
    card_index = (show_command.split(' '))[1]
    puts 'Please enter the new level of importance'
    new_importance = gets.chomp
    card = Contact.find_by(id: card_index)
    card.importance = new_importance
    card.save
    puts "Updated record: #{card.id}: #{card.importance}"
  end

  #What is the way to allow this method to take 0 or 1 arguments?
  def add_phone_number
    phone_number_hash = {}
    begin
      puts "Enter a phone number location"
      phone_number_location = gets.chomp
      puts "Enter a phone number (digits only)"
      phone_number = gets.chomp
      phone_number_hash[phone_number_location] = phone_number
      puts "Phone Number Added"
      puts "Would you like to enter another?"
      user_response_phone = gets.chomp
    end while (user_response_phone != 'no')
    return flatten_phone_hash(phone_number_hash)
  end

  def add_phone_number_to_record( card_index )
    phone_number_string = add_phone_number
    card = Contact.find_by(id: card_index)
    card.phone = card.phone + ' ' + phone_number_string
    card.save
    puts "Phone number(s) added"
  end

  def list_most_important
    important_cards = Contact.where("importance != 'nil'").order('importance DESC')
      important_cards.each do |contact|
        record = contact.first_name.to_s + ' ' + contact.last_name.to_s + ' ' + contact.importance.to_s
        puts record
      end
  end

  def find_contact(find_command)
    search_term = (find_command.split(' '))[1]
    found_cards = Contact.where(["first_name LIKE :fname OR email LIKE :email", {:fname => "%#{search_term}%", :email => "%#{search_term}%"}])
      found_cards.each do |contact|
        record = contact.first_name.to_s + ' ' + contact.last_name.to_s + ' ' + contact.email.to_s
        puts record
      end
  end

  def flatten_phone_hash(phone_number_hash)
    phone_number_hash.map{ |x,y| "#{x}: #{y}"}.join(',')
  end
 
end
