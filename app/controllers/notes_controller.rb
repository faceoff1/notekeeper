class NotesController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :find_note!, only: [:destroy]
  ITEMS_PER_PAGE = 5

  def index
    @pagy, @notes = pagy(Note.includes(:user).order(created_at: :asc), items: ITEMS_PER_PAGE, size: [1, 1, 1, 1])
  rescue Pagy::OverflowError => e
    redirect_to root_path(page: e.pagy.last)
  end

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      redirect_to root_path(page: current_page), notice: 'Note created successfully.'
    else
      redirect_to root_path(page: current_page), alert: 'Failed to create note.'
    end
  end

  def destroy
    @note.destroy
    redirect_to root_path(page: current_page), notice: 'Note deleted successfully.'
  end

  private

  def current_page
    match = request.headers['HTTP_REFERER']&.match(/page=(\d+)/)
    return 1 if match.nil?

    match[1]
  end

  def find_note!
    @note = Note.find_by!(user: current_user, id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Note not found'
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
