class SongsController < ApplicationController
  before_action :set_song, only: [:update, :destroy, :edit]
  before_action :set_preference, only: [:index, :new]

  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @preference ? (@songs = @artist.songs.order(title: @preference.song_sort_order)) : (@songs = @artist.songs)
      end
    else
      @preference ? (@songs = Song.order(title: @preference.song_sort_order)) : (@songs = Song.all)
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        redirect_to artist_songs_path(@artist), alert: "Song not found"
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if @preference && !@preference.allow_create_songs
     redirect_to songs_path
    else
      @song = Song.new
    end
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
  end

  def update
    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
  def set_song
    @song = Song.find(params[:id])
  end
  def set_preference
    @preference = Preference.first
  end
end
