class EntriesController < ApplicationController

  def index
    @entry = Entry.paginate(page: params[:page])
  end

  def show
    @entry = Entry.find(params[:id])
    @comments = @entry.comments
    respond_to do |format|
        format.html { redirect_to request.referrer }
        format.js
    end
  end

  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Entry created!"
      redirect_to root_url
    else
      @feed_items = []
      #flash[:danger] = "Entry not created!"
      render 'static_pages/home'
      #redirect_to root_url
    end
  end

  def destroy
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to request.referrer || root_url
  end

  def edit
    @Entry = Entry.find(params[:id])
    respond_to do |format|
        format.html {redirect_to request.referrer}
        format.js
    end
  end

  def update
    @entry = Entry.find(params[:id])
    if @entry.update_attributes(entry_params)
      respond_to do |format|
        format.html {redirect_to request.referrer}
        format.js
    end
    else
      render 'edit'
    end
  end

  private

    def entry_params
        params.require(:entry).permit(:title,:body,:picture)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
end
end
