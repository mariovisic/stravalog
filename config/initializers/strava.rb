STRAVA_API_CLIENT = Strava::Api::V3::Client.new(:access_token => ENV['STRAVA_API_TOKEN'], :logger => Rails.logger)
