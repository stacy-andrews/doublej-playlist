require "doublej_playlist/version"
require 'rest-client'
require 'terminal-notifier'
require 'byebug'
require 'date'
require 'doublej_playlist/stations/double_j'
require 'doublej_playlist/stations/andrew_haug'

module DoublejPlaylist
  class Playlist
    def self.go(options)
      station = find_station(options[:station_code])
      
      start_stream station

      every options[:sample_duration] do 
        check station
      end
    end

    private 

    def self.find_station(station_code)
      station_code == 'AH' ? AndrewHaug.new : DoublejPlaylist::DoubleJ.new
    end
    
    def self.every(seconds)
      while 
        yield
        sleep seconds
      end
    end

    def self.start_stream(station)
      job = fork do
        exec "mpg123 #{station.stream_url}"
      end

      Process.detach(job)
    end

    def self.check(station)
      new_song = station.current_song

      if song_changed? new_song
        show new_song, station.name
      end
      
      @last_song = new_song
    end

    def self.song_changed?(new_song)
      @last_song == nil || @last_song[:artists] != new_song[:artists] && @last_song[:title] != new_song[:title]
    end

    def self.show(song, station_name)
      song_desc = "#{song[:artists]} - #{song[:title]}\n"

      puts song_desc
      TerminalNotifier.notify song_desc, title: station_name
    end
  end
end
