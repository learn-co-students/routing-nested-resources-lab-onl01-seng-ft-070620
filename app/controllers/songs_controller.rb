class SongsController < ApplicationController
  # account for whether user wants all songs or all songs by an artist
  # account for whether a requested artist actually exists
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.present?
        @songs = @artist.songs
      else # if the artist doesn't exist
        redirect_to artists_path, flash: {alert: "Artist not found"}
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.blank? # if the song doesn't exist
        redirect_to artist_songs_path(@artist), flash: {alert: "Song not found"}
      end
    else
      @song = Song.find_by(id: params[:id])
    end
  end

  def new
    @song = Song.new
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
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name, :artist_id)
  end
end
