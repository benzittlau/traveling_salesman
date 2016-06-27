class BaseRouter
  def initialize(locations)
    @locations = locations
    @routed_locations = nil
  end

  def route
    raise "A router must implement the route method"
  end

  def route_info
    waypoints = @routed_locations.map(&:combined)
    drive_time = drive_time_from_sequence(@routed_locations)

    {
      :waypoints => waypoints,
      :drive_time => drive_time
    }
  end

  def drive_time_from_sequence(locations)
    cumulative_time = 0
    locations.size.times do |index|
      from = locations[index]
      to = locations[index + 1]
      break if to.nil?

      cumulative_time += from.drive_time_to(to)
    end

    cumulative_time
  end
end
