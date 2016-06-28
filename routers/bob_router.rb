class BobRouter < BaseRouter

  STEPS = 3
  N_NEIGHBOURS = 3

  def route
    first = find_closest(edmonton_se_point, @locations)
    @routed_locations = []

    remaining_locations = @locations.clone
    remaining_locations.delete(first)
    next_location = first

    while(!remaining_locations.empty?) do
      @routed_locations << next_location

      next_location = get_next_location(next_location, remaining_locations)
      remaining_locations.delete(next_location)
    end
  end

  def get_next_location(location, remaining_locations)
    shortest_n_destinations(location, N_NEIGHBOURS, remaining_locations).map{|destination| 
      [destination, score(destination, STEPS, remaining_locations) + location.drive_time_to(destination)]
    }.sort_by{|a| a[1]}.first[0]
  end

  def find_closest(ref_point, locations)
    min = @locations[0]

    @locations.each{|loc|
      if lat_long_distance(ref_point, min) >
            lat_long_distance(ref_point, loc)
          min = loc
        end
    }
    return min
  end

  def score(location, steps, remaining_locations)
    virtual_remaining = remaining_locations.clone
    virtual_remaining.delete(location)
    return 0 if virtual_remaining.empty?
    
    if steps == 0
      begin
        return shortest_destination(location, virtual_remaining).drive_time_to(location)
      rescue
        binding.pry
      end
    else
      return shortest_n_destinations(location, N_NEIGHBOURS, virtual_remaining).map{|destination| 
          score(destination, steps-1, virtual_remaining)
      }.sort.first
    end
  end

  def nearest_route
    @routed_locations = []
    remaining_locations = @locations.clone

    next_location = remaining_locations.shift

    while(!remaining_locations.empty?) do
      @routed_locations << next_location

      next_location = shortest_destination(next_location, remaining_locations)
      remaining_locations.delete(next_location)
    end
  end

  def edmonton_center_point
    return lat_long(53.535446, -113.500155)
  end

  def edmonton_nw_point
    return lat_long(53.642832, -113.622412)
  end

  def edmonton_se_point
    return lat_long(53.408065, -113.352651)
  end

  def lat_long_distance(from_tuple, to)
    (from_latitude, from_longitude) = from_tuple
    d_lat = from_latitude - to.latitude.to_f
    d_long = from_longitude - to.longitude.to_f
    Math.sqrt(d_lat**2 + d_long**2)
  end

  def lat_long(lat, long)
    return [lat, long]
  end

  def shortest_destination(source, remaining_destinations)
    remaining_destinations.
      sort_by{|d| source.drive_time_to(d)}.
      first
  end

  def shortest_n_destinations(source, n, remaining_destinations)
    remaining_destinations.
      sort_by{|d| source.drive_time_to(d)}.
      first(n)
  end  

end