require_relative "../../lib/genius/data_processors/search_all_type_extractor"
require "byebug"
RSpec.describe DataProcessors::SearchAllTypeExtractor do
  let(:response) do
    {
      "response" => {
        "sections" => [
          {
            "type" => "top_hit",
            "hits" => [
              {
                "type" => "album"
              },
              {
                "type" => "artist",
                "result" => {
                  "id" => 498,
                  "name" => "Beyonce"
                }
              }
            ]
          },
          {
            "type" => "artist",
            "hits" => [
              {
                "type" => "artist",
                "result" => {
                  "id" => 498,
                  "name" => "Beyonce"
                }
              },
              {
                "type" => "artist",
                "result" => {
                  "id" => 500,
                  "name" => "Michel"
                }
              }
            ]
          }
        ]
      }
    }
  end
  describe "#top_hits" do
    it "extracts top_hits from response" do
      top_hit = DataProcessors::SearchAllTypeExtractor.new(response: response).top_hits
      expect(top_hit).to eq(
        [
          {"type"=>"album"},
          {"type"=>"artist", "result"=>{"id"=>498, "name"=>"Beyonce"}}
        ]
      )
    end
  end

  describe "#hits" do
    it "extracts hits from response" do
      hits = DataProcessors::SearchAllTypeExtractor.new(response: response).hits
      expect(hits).to eq(
        [
          {
            "type"=>"artist",
            "hits"=>[
              {
                "type"=>"artist",
                "result"=>{"id"=>498, "name"=>"Beyonce"}
              },
              {
                "type"=>"artist",
                "result"=>{"id"=>500, "name"=>"Michel"}
              }
            ]
          }
        ]
      )
    end
  end

  describe "#artists" do
    it "extracts artists from response" do
      artists = DataProcessors::SearchAllTypeExtractor.new(response: response).artists
      expect(artists[0]).to eq(Models::Artist.new(498, "Beyonce"))
      expect(artists[1]).to eq(Models::Artist.new(500, "Michel"))
    end
  end
end