require_relative "api"
require_relative "data_processors/search_all_type_extractor"
require_relative "data_processors/song_extractor"
require_relative "presenters/songs_view"

module Genius
  class SongsByArtist
    attr_reader :access_token, :artist_name, :presenter

    def initialize(access_token:, artist_name:, presenter: Presenters::SongsView)
      @access_token = access_token
      @artist_name = artist_name
      @presenter = presenter
    end

    def perform
      api = API.new(access_token: access_token)
      artists_response = api.search(artist_name)
      artists = DataProcessors::SearchAllTypeExtractor.new(response: artists_response).artists
      songs_response = api.songs(artist_id: artists.first.id)
      songs = DataProcessors::SongExtractor.new(response: songs_response).songs
      presenter.new(songs: songs).display
    end
  end
end