require_relative "../models/song"

module DataProcessors
  class SongExtractor
    attr_reader :response

    def initialize(response:)
      @response = response
    end

    def songs
      response["response"]["songs"].map do |song|
        Models::Song.new(song["id"], song["title"])
      end
    end
  end
end