class RandomRouter < BaseRouter
  def route
    min = nil

    2999999.times do
      locations = @locations.clone
      random_order = locations.sample(@locations.size)
      min = random_order if min.nil? || drive_time_from_sequence(random_order) < drive_time_from_sequence(min)
    end
    @routed_locations = min
  end
end
