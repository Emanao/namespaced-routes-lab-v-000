class Admin::PreferencesController < ApplicationController
  
  def index
    @preferences = Preference.first_or_create(song_sort_order: "DESC", artist_sort_order: "DESC", allow_create_songs: true, allow_create_artists: true)
  end

  def update
    @preferences = Preference.find(params[:id])
    @preferences.update(preference_params)
    redirect_to admin_preferences_path
  end

  private
  def preference_params
    params.require(:preference).permit(:song_sort_order, :artist_sort_order, :allow_create_songs, :allow_create_artists)
  end
end
