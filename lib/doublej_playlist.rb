require "doublej_playlist/version"
require 'rest-client'
require 'terminal-notifier'
require 'logger' 

$stdout.sync = true

module DoublejPlaylist
  class Playlist
    def self.go
      @logger = Logger.new($stdout)

      every 10 do 
        check
      end
    end

    private 
    
    def self.check

      response = RestClient.get 'http://music.abcradio.net.au/api/v1/plays/doublej/now.json'

      payload = JSON.parse(response.body)

      recording = payload['now']['recording']

      artist_names = recording['artists'].reduce('') { |memo, artist| memo << "#{artist['name']}, " }

      @logger.info "next #{payload['next_updated']}"
      new_song = "#{artist_names}\n#{recording['title']}"

      @logger.info "\n" + new_song
      TerminalNotifier.notify new_song, title: 'double j' if new_song != @last_song

      @last_song = new_song
    end

    def self.every(seconds)
      while 
        yield
        sleep seconds
      end
    end
  end
end
