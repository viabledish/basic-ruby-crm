class Application

    EXIT_CMD = 'exit'
    NEW_CMD = 'new'
    LIST_CMD = 'list'
    LIST_IMPORTANT_CMD = 'list important'
    EDIT_NAME_CMD = 'edit name'
    ADD_PHONE_CMD = 'add phone'
    EDIT_EMAIL_CMD = 'edit email'
    EDIT_IMPORTANT_CMD = 'edit importance'
    BACK_CMD = 'back'
    PHONE_CMD = 'phone'
    SHOW_CMD = 'show '
    DELETE_CMD = 'delete '
    FIND_CMD = 'find '
 
  def run
    begin 
      show_main_menu
      input = gets.chomp

      case input
      when (NEW_CMD)
        create_new_card(NEW_CMD)

      when (LIST_CMD)
        list_cards

      when (LIST_IMPORTANT_CMD)
        list_most_important

      when /#{DELETE_CMD}\d+/
        delete_card(input)
      

      when /#{FIND_CMD}\d+/
        find_contact(input)
      
      when /#{SHOW_CMD}\d+/
        show_card(input)

      end  #end case    
    end while (input != EXIT_CMD)
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

    # Split first name, last name
    f_name, l_name = full_name.split 

    # Add card to ActiveRecord
    new_card = Contact.new(first_name: f_name, last_name: l_name, email: email_address, importance: importance_rating)
    if (new_card.save == true)
      puts "Would you like to add a phone number"
      user_response_phone = gets.chomp
      if (user_response_phone == 'yes')
        add_phone_number(new_card.id)
      end
      puts "Contact #{new_card.id.to_s}: #{new_card.first_name} #{new_card.last_name} created."
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

  def edit_mode(card_index)
    begin
      edit_cmd = gets.chomp
      if (edit_cmd == EDIT_NAME_CMD)
        edit_name(card_index)
      elsif (edit_cmd == EDIT_EMAIL_CMD)
        edit_email(card_index)
      elsif (edit_cmd == ADD_PHONE_CMD)
        add_phone_number(card_index)
      elsif (edit_cmd == EDIT_IMPORTANT_CMD)
        edit_importance(card_index) 
      else
        puts 'Please enter a valid command'
      end
      end while (edit_cmd != BACK_CMD)
  end

  def show_card(show_command)
    card_index = (show_command.split(' '))[1]
    if (Contact.find_by(id: card_index).nil?)
      puts "The card does not exist!"
    else
      card = Contact.find_by(id: card_index)
      puts "#{card_index}: " + "#{card.first_name} #{card.last_name}"
      show_edit_menu
      edit_mode(card_index)
    end
  end

  def delete_card(delete_command)
    card_index = (delete_command.split(' '))[1]
    if (Contact.find_by(id: card_index).nil?)
      puts "The card does not exist!"
    else
      card = Contact.find_by(id: card_index)
      card.destroy
      puts "Record #{card_index} no longer exists!"
    end
  end

  def edit_name(card_index)
    puts 'Please enter the new name'
    new_name = gets.chomp
    card = Contact.find_by(id: card_index)
    f_name, l_name = new_name.split
    card.first_name = f_name
    card.last_name = l_name
    card.save
    puts "Updated record: #{card.id}: #{card.first_name} #{card.last_name}"
    show_edit_menu
  end

  def edit_email(card_index)
    puts 'Please enter the new email address'
    new_email = gets.chomp
    card = Contact.find_by(id: card_index)
    card.email = new_email
    if (card.save == true)
      puts "Updated record: #{card.id}: #{card.email}"
      show_edit_menu
    else
      puts "Email exists!"
      show_edit_menu
    end
  end

  def edit_importance(card_index)
    puts 'Please enter the new level of importance'
    new_importance = gets.chomp
    card = Contact.find_by(id: card_index)
    card.importance = new_importance
    card.save
    puts "Updated record: #{card.id}: #{card.importance}"
    show_edit_menu
  end

  def add_phone_number(card_index)
    begin
      puts "Enter a phone number location"
      phone_number_location = gets.chomp
      puts "Enter a phone number (digits only)"
      phone_number = gets.chomp
      new_phone = Phone.new(f_id: card_index, location: phone_number_location, phone_number: phone_number)
      if (new_phone.save == true)
        puts "Phone Number Added"
      else
        puts "There was an error adding your phone number"
      end
      puts "Would you like to enter another?"
      user_response_phone = gets.chomp
    end while (user_response_phone != 'no')
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
 
end
