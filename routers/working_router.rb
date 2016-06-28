class WorkingRouter < BaseRouter
  def route
    @routed_locations = []
    current_shortest_time = 999999
    starting_point = 0

    stops = @locations.length-1

    for i in 0..stops
      temp_routed_locations = []
      remaining_locations = @locations.clone

      #swap
      remaining_locations[0], remaining_locations[i] = remaining_locations[i], remaining_locations[0]

      next_location = remaining_locations.shift

      while(!remaining_locations.empty?) do
        temp_routed_locations << next_location
        next_location = shortest_destination(next_location, remaining_locations)
        remaining_locations.delete(next_location)
      end

      new_time = drive_time_from_sequence(temp_routed_locations)
      # puts current_shortest_time
      # puts new_time
      if (new_time < current_shortest_time)
        @routed_locations = temp_routed_locations
        current_shortest_time = new_time
        starting_point = i
      end
    end

    # puts "starting point #{starting_point}"

  end

  def shortest_destination(source, remaining_destinations)
    remaining_destinations.
      sort_by{|d| source.drive_time_to(d)}.
      first
  end

end
