# app.rb
require "sinatra"
require "sinatra/activerecord"
require_relative "contact"

set :database, "sqlite3:///db/db.sqlite"

get "/" do
	@contacts = Contact.order("importance DESC")
	erb :"contacts/index"
end

get "/contacts/new" do
	@title = "New Contact"
	@contact = Contact.new
	erb :"contacts/new"
end

post "/contacts" do
	@contact = Contact.new(params[:contact])
  if @contact.save
    redirect "contacts/#{@contact.id}"
  else
    erb :"contacts/new"
  end
end

# Get the individual page of the contact with this ID.
get "/contacts/:id" do
  @contact = Contact.find(params[:id])
  @first_name = @contact.first_name
  erb :"contacts/show"
end

# Get the Edit Post form of the contact with this ID.
get "/contacts/:id/edit" do
  @contact = Contact.find(params[:id])
  @title = "Edit Contact"
  erb :"contacts/edit"
end

put "/contacts/:id" do
  @contact = Contact.find(params[:id])
  if @contact.update_attributes(params[:contact])
    redirect "/contacts/#{@contact.id}"
  else
    erb :"contacts/edit"
  end
end

# Deletes the post with this ID and redirects to homepage.
delete "/contacts/:id" do
  @contact = Contact.find(params[:id]).destroy
  redirect "/"
end

# Our About Me page.
get "/about" do
  @title = "About Me"
  erb :"pages/about"
end

helpers do
  # If @title is assigned, add it to the page's title.
  def title
    if @title
      "#{@title} -- Contacts"
    else
      "My Contacts"
    end
  end

  def contact_show_page?
    request.path_info =~ /\/contacts\/\d+$/
  end

  def delete_contact_button(contact_id)
    erb :_delete_contact_button, locals: { id: contact_id}
  end
end