require_relative "../models/artist"

module DataProcessors
  class SearchAllTypeExtractor
    attr_reader :response

    module Types
      TOP_HITS = "top_hit"
      ARTIST = "artist"
    end

    def initialize(response:)
      @response = response
    end

    def top_hits
      response["response"]["sections"].select { |section| section["type"] == Types::TOP_HITS }[0]["hits"]
    end

    def hits
      response["response"]["sections"].select { |section| section["type"] != Types::TOP_HITS }
    end

    def artists
      top_selection = top_hits.select { |hit| hit["type"] == Types::ARTIST }
      extras = hits.select { |hit| hit["type"] == Types::ARTIST }[0]["hits"]
      total_selection = top_selection + extras
      total_selection.map do |artist|
        Models::Artist.new(artist["result"]["id"], artist["result"]["name"])
      end.uniq
    end
  end
end