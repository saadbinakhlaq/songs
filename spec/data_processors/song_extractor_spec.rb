require_relative "../../lib/genius/data_processors/song_extractor"

RSpec.describe DataProcessors::SongExtractor do
  describe "#songs" do
    it "returns a list of songs from the response" do
      response = {
        "response" => {
          "songs" => [
            {
              "id" => 1,
              "title" => "song_1"
            },
            {
              "id" => 2,
              "title" => "song_2"
            }
          ]
        }
      }

      songs = DataProcessors::SongExtractor.new(response: response).songs
      expect(songs[0]).to eq(Models::Song.new(1, "song_1"))
      expect(songs[1]).to eq(Models::Song.new(2, "song_2"))
    end
  end
end