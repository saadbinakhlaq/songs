#!/usr/bin/env ruby
require "thor"
require_relative "songs_by_artist"

class CLI < Thor
  default_task :genius
  desc "Genius interface", "--token --artist"
  option :token, required: true, type: :string
  option :artist, required: true, type: :string

  class ValidationError < StandardError
  end

  def genius
    validations(args, options)

    Genius::SongsByArtist.new(access_token: options[:token], artist_name: options[:artist]).perform
  end

  private

  def validations(args, options)
    if args.size > 0
      puts "Use as $ bundle exec lib/genius/cli.rb genius --token=asdasda --artist='Kayne West'"
      return
    end

    abort("No value provided for option '--token'") if options[:token].nil? || options[:token] == ""
    abort("No value provided for option '--artist'") if options[:artist] == nil || options[:artist] == ""
  end

  def self.exit_on_failure?
    0
  end
end

CLI.start(ARGV)