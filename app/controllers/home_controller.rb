class HomeController < ApplicationController
  def index
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
  def search
    @query = params[:query]
    #@owners = Owner.search(@query)
    #@pets = Pet.search(@query)
    @owners = Owner.search_by_owner_name(@query)
    @pets = Pet.search_by_pet_name(@query)
    @total_hits = @owners.size + @pets.size
  end

end