class Contact
  
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :email
  attr_accessor :phone
  
  def initialize(name, email, phone)
    @first_name = name.split(' ')[0]
    @last_name = name.split(' ')[1]
    @email = email
    @phone = phone
  end

  def edit_contact_name(name)
  	@first_name = name.split(' ')[0]
    @last_name = name.split(' ')[1]
  end

  def edit_contact_email(email)
  	@email = email
  end
  
  def to_s
  	phone_numbers = @phone.each { |x, y| puts "#{x}: #{y}"}
    @first_name + ' ' + @last_name + ' (' + @email + ') ' + phone_numbers.to_s
  end

  
end
