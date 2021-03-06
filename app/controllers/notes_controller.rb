# controller for notes
class NotesController < ApplicationController
  def create
    @note = Note.create(note_params)
    flash[:info] = "Note successfully added"

    render json: @note
  end

  def note_params
    params.require(:note).permit(:author, :body, :application_tag_id, :test_id)
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    flash[:info] = "Note successfully removed"
    head :no_content
  end
end
