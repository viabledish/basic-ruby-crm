class Contact
  
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :email
  
  def initialize(name, email)
    @first_name = name.split(' ')[0]
    @last_name = name.split(' ')[1]
    @email = email
  end
  
  def to_s
    @first_name + ' ' + @last_name + ' (' + @email + ')'
  end
  
end
