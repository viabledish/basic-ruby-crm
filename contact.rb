class Contact < ActiveRecord::Base

  validates :email,       presence: true, uniqueness: { case_sensitive: false }
  validates :importance,  numericality: { only_integer: true, greater_than: 1, less_than: 5 }
  
end
