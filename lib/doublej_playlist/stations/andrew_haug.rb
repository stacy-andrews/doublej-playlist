module DoublejPlaylist
  class AndrewHaug
    def name
      'Andrew Haug'
    end
    
    def stream_url
      'http://majestic.wavestreamer.com:2876/stream/1/'
    end

    def current_song
      response = RestClient.get 'http://p5.radiocdn.com/player.php?hash=125c271001086c7e81d3f61adc3e0c835bc66f1e&action=getCurrentData&_=1514606477760'
      
      payload = JSON.parse(response.body)

      {
        artists:  payload['artist'],
        title:    payload['track']
      }
    end
  end
end
