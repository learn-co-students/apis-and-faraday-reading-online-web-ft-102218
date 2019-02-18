class SearchesController < ApplicationController
  def search
  end
  
  def foursquare
    begin
      @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
        req.params['client_id'] = nil
        req.params['client_secret'] = nil
        req.params['v'] = '20190218'
        req.params['near'] = params[:zipcode]
        req.params['query'] = 'coffee shop'
      end
      body_hash = JSON.parse(@resp.body)
      if @resp.success?
        @venues = body_hash['response']['venues']
      else
        @error = body_hash["meta"]["errorDetails"]
      end
    rescue Faraday::ConnectionFailed
      @error = 'There was a timeout.'
    end
    render 'search'
  end
end
