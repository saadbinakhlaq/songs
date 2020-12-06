RSpec.describe Genius::API do
  describe "#search" do
    it "searches for all data", vcr: { cassette_name: "api/search" } do
      results = Genius::API.new(access_token: "asdds").search("Lil Wayne")
      expect(results["response"]["sections"][0]["type"]).to eq("top_hit")
    end
  end

  describe "#songs", vcr: { cassette_name: "api/songs" } do
    it "searches for all songs" do
      token = "YDjRo-ug-KzRXXAKw9Tz7qRByYO1D54qA8tFZJXmTArBcfm4JsZRt0Fu0ODA78Ep"
      results = Genius::API.new(access_token: token).songs(artist_id: 498)
      expect(results["response"]["songs"]).to be
    end
  end

  describe "#songs_per_page", vcr: { cassette_name: "api/songs_per_page" } do
    it "searches for all songs" do
      token = "YDjRo-ug-KzRXXAKw9Tz7qRByYO1D54qA8tFZJXmTArBcfm4JsZRt0Fu0ODA78Ep"
      results = Genius::API.new(access_token: token).songs_per_page(artist_id: 498)
      expect(results["response"]["songs"]).to be
    end
  end
end