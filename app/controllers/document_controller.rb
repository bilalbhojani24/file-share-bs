class DocumentController < ApplicationController
  before_action :private_route
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @document = current_user.documents.order!(created_at: :desc) 
  end
  
  def show
    @document = Document.find_by!(key: params[:id], shared: true)
    @user = User.find(@document[:user_id]) if @document
  end
 
  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)
    @document.save
    redirect_to '/'
  end

  def update
    @checked = (params[:document] && (params[:document][:shared] == '1')) ? true : false
    @document = current_user.documents.find_by!(id: params[:id])
    @document && @document.update(shared: @checked) 
    flash[:notice] = "Status updated successfully!"
    redirect_to '/'
  end

  def destroy
    @document = current_user.documents.find_by!(id: params[:id])
    @document && @document.user_document.purge_later
    @document && @document.destroy
    redirect_to '/'
  end

  private

  def document_params
    params.require(:document).permit(:user_document).merge(key: "#{SecureRandom.hex(6)}#{Time.now.to_i}")
  end

  def correct_user
    @document = current_user.documents.find_by(id: params[:id])
    redirect_to "/", notice: "Not Authorized to perform this action" if @document.nil?
  end
  
end
