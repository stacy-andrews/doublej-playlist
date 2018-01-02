module DoublejPlaylist
  class DoubleJ
    def name
      'Double J'
    end

    def stream_url
      'http://live-radio01.mediahubaustralia.com/DJDW/mp3/'
    end

    def current_song
      now = DateTime.now
      to = now.to_s.gsub('+', '%2B')
      from = (now - (10/1440.0)).to_s.gsub('+', '%2B')
      
      response = RestClient.get 'http://music.abcradio.net.au/api/v1/plays/search.json?from=' + from +  '&limit=10&offset=0&page=0&station=doublej&to=' + to

      payload = JSON.parse(response.body)

      recording = payload["items"][0]["recording"]

      artist_names = recording['artists'].reduce('') { |memo, artist| memo << "#{artist['name']}, " }

      {
        artists:  artist_names,
        title:    recording['title']
      }
    end
  end
end