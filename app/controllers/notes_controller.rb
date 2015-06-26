class NotesController < ApplicationController

  def create
    note = Note.new(note_params)
    if note.save
      render json: note, status: :ok
    else
      render json: nil, status: :error
    end
  end

  def index
    render json: current_user.notes
  end

  def destroy
    if Note.find(params[:id]).destroy
      render json: nil, status: :ok
    end
  end

  def show
    render json: Note.find(params[:id])
  end

  def update
    begin
      if current_user.id == Note.find(params[:id]).user_id
        note = Note.find(params[:id])
        note.update_attributes(note_params)
        render json: note, status: :ok
      else
        render json: nil, status: :error
      end
    end rescue render json: nil, status: :error
  end

  private

  def note_params
    params.require(:note).permit(:title, :body, :user_id)
  end
end
