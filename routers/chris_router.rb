class ChrisRouter < BaseRouter
  def route
    @routed_locations = []
    start_locations = @locations.clone

    first_point = [];
    threads = []

    start_locations.each do |start_location|
      threads << Thread.new do
        first_point << getInfoAboutStartingPoint(start_location, @locations.clone)
      end
    end

    threads.each(&:join)
    best_starting_point = first_point.sort_by{|point| point[:drive_time]}.first


    threads = []
    second_point = [];
    new_locations = best_starting_point[:routed_locations].clone
    new_locations.delete(best_starting_point[:first_point])

    new_locations.each do |second_location|
      threads << Thread.new do
        second_point << getInfoAboutStartingPoint(second_location, new_locations.clone)
      end
    end

    threads.each(&:join)
    best_second_point = second_point.sort_by{|point| point[:drive_time] }.first
    @routed_locations = best_second_point[:routed_locations]

  end

  def shortest_destination(source, remaining_destinations)
    remaining_destinations.
        sort_by{|d| source.drive_time_to(d)}.
        first
  end


  def getInfoAboutStartingPoint(start_location, locations)
    next_location = start_location
    routed_locations = []

    locations.delete(start_location)

    while(!locations.empty?) do
      routed_locations << next_location

      next_location = shortest_destination(next_location, locations)
      locations.delete(next_location)

    end

    drive_time = get_route_info(routed_locations)[:drive_time]

    return {:drive_time => drive_time, :start_location => start_location, :routed_locations => routed_locations}
  end

  def get_route_info(routed_locations)
    waypoints = routed_locations.map(&:combined)
    drive_time = drive_time_from_sequence(routed_locations)

    {
        :waypoints => waypoints,
        :drive_time => drive_time
    }
  end

end
