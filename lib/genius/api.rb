
# frozen_string_literal: true
require "httparty"

module Genius
  class API
    class APIError < StandardError
    end

    attr_reader :access_token, :response
    BASE_URL = "https://api.genius.com"
    OPEN_BASE_URL = "https://genius.com"
    DEFAULT_TIMEOUT = 20

    def initialize(access_token:)
      @access_token = access_token
    end

    def search(search_term)
      perform(method: :get,
        url: "#{OPEN_BASE_URL}/api/search/multi",
        query: { q: search_term }
      )
    end

    def songs_per_page(artist_id:, page: 1, per_page: 20)
      perform(method: :get,
        url: "#{BASE_URL}/artists/#{artist_id}/songs?page=#{page}?per_page=#{per_page}",
        headers: authentication_header
      )
    end

    def songs(artist_id:)
      next_page = 1
      total_songs = { "response" => { "songs" => [] } }
      while !next_page.nil?
        response = songs_per_page(artist_id: artist_id, page: next_page)
        if !response["response"]["songs"].nil?
          total_songs["response"]["songs"] += response["response"]["songs"]
        end
        next_page = response["response"]["next_page"]
        break if next_page.to_i == 3
      end
      total_songs
    end

    private

    def perform(method: :get, url:, query: nil, headers: nil, body: nil, timeout: DEFAULT_TIMEOUT)
      options = {}
      options[:timeout] = timeout
      options[:headers] = headers unless headers.nil?
      options[:query] = query unless query.nil?
      options[:body] = body unless body.nil?

      @response = HTTParty.send(
        method,
        url,
        options
      )

      case
      when response.success?
        JSON.parse(response.body)
      when response.request_timeout?
        on_timeout
      else
        on_failed
      end
    end

    def on_failed
      raise APIError, @response.body
    end

    def on_timeout
      raise APIError, "Timedout"
    end

    def authentication_header
      {
        "Authorization" => "Bearer #{access_token}"
      }
    end
  end
end