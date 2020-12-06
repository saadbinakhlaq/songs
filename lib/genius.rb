require "genius/version"
require "genius/api"
require "genius/songs_by_artist"
require "genius/cli"
require "genius/data_processors/search_all_type_extractor"
require "genius/data_processors/song_extractor"
require "genius/models/song"
require "genius/models/artist"
require "genius/presenters/songs_view"

module Genius
  class Error < StandardError; end
  # Your code goes here...
end
