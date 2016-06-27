class Here
  include HTTParty
  def self.creds
    {:app_id => ENV['HERE_ID'], :app_code => ENV['HERE_CODE']}
  end

  def self.matrix(starts, destinations, options={})
    defaults = {
      :summaryAttributes => 'traveltime',
      :mode => "fastest;car;traffic:disabled"
    }
    options = defaults.merge(options)

    starts.each_with_index do |location, index|
      options["start#{index}"] = location
    end

    destinations.each_with_index do |location, index|
      options["destination#{index}"] = location
    end

    response = get_url("https://matrix.route.cit.api.here.com/routing/7.2/calculatematrix.json", options)

    binding.pry unless response.dig("response", "matrixEntry")
    response.dig("response", "matrixEntry").map{|e| e.dig("summary", "travelTime")}
  end

  def self.route(options={})
    get_url("https://route.cit.api.here.com/routing/7.2/calculateroute.json", options)
  end

  def self.geocode(options = {})
    response = get_url("https://geocoder.cit.api.here.com/6.2/geocode.json", options)

    response.dig("Response", "View", 0, "Result", 0, "Location", "DisplayPosition")
  end

  def self.get_url(url, options = {})
    options.merge!(creds)
    get(url, {:query => options})
  end
end
