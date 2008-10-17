require 'rhocontroller'

class ContactsController < RhoController

  def index
	
    account = Account.new
    account.name = 'Vlad'
    puts 'Account name: ' + account.name
    #@message = "List of contacts"
    render :index
  end

  def new
    render :new
  end
	
  def create
    @message = "Created new contact w/ params: " + @params.to_s
    redirect :show, 10
  end
	
  def show
    @message = "Show contact record: " + @params['id']
    render :show
  end
	
  def edit
    render :edit
  end
	
  def update
    puts "Updated record: " + @params['id']
    redirect :show, @params['id']
  end
	
  def delete
    puts "Deleted record: " + @params['id']
    redirect :index
  end
end
