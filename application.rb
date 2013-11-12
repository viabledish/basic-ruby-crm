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
    @show_cmd = 'show'

  end
 
  def run
    begin 
        show_main_menu
        input = gets.chomp
        case input
          when (@new_cmd)
            puts "Enter a first and last name"
            full_name = gets.chomp
            puts "Enter an email address"
            email_address = gets.chomp

            @contacts.each do |i|
                if (i.email == email_address)
                  puts "Email already exists!" 
                else
                  puts "#{email_address}" + " #{full_name}"
                  new_card = Contact.new(full_name, email_address)
                  @contacts << new_card
                  puts 'Contact ' + new_card.to_s + ' created.'
                end
                break
            end
          
          when (@list_cmd)
            @contacts.each_with_index { |val, index| puts "#{index}: " + "#{@contacts[index]}"}
          
          when ('the'.to_s == 'the'.to_s)
            puts "Remember, the index starts at 0!"

            #card_index = gets.chomp.split[1]
            #puts "#{@contacts}[card_index]"
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
 
end
