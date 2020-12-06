module Presenters
  class SongsView
    attr_reader :songs

    def initialize(songs:)
      @songs = songs
    end

    def display

      songs.each do |song|
        puts "#{song.title}"
      end
      return
    end
  end
end