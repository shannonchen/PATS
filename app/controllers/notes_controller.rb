class NotesController < ActionController::Base

	def new
	 @note = Note.new
	 @notable = find_notable
	end

 	def index  
      @notable = find_notable  
      @notes = @notable.notes
    end  

	def create
	  @notable = find_notable
	  @note = @notable.notes.build(params[:note])
	  if @note.save
	    flash[:notice] = "Successfully created note."
	    redirect_to @notable
	  else
	    render :action => 'new'
	  end
	end

# have the things be set as current user and current date

	def edit
  	end	

  	def update
  	end

	def destroy
	 	@notable = find_notable
	    @note.destroy
	    redirect_to @noteable, :notice => "Removed note"
  	end



	def find_notable
	  params.each do |name, value|
	    if name =~ /(.+)_id$/
	      return $1.classify.constantize.find(value)
	    end
	  end
	  nil
	end

end
