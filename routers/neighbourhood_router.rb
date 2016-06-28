class NeighbourhoodRouter < BaseRouter
  def route
    southest_location = get_southest_location
    northest_location = get_northest_location
    westest_location = get_westest_location
    eastest_location = get_eastest_location
    y_middle = get_middle_point(northest_location.latitude, southest_location.latitude)
    x_middle = get_middle_point(eastest_location.longitude, westest_location.longitude)
    quadrants = [[], [], [], []]
    @locations.each do |location|
      if location.latitude.to_f > y_middle && location.longitude.to_f > x_middle
        quadrants[0] << location
      elsif location.latitude.to_f > y_middle && location.longitude.to_f < x_middle
        quadrants[1] << location
      elsif location.latitude.to_f < y_middle && location.longitude.to_f > x_middle
        quadrants[2] << location
      elsif location.latitude.to_f < y_middle && location.longitude.to_f < x_middle
        quadrants[3] << location
      end
    end
    quadrants.each.with_index do |quadrant, index|
      quadrants[index] = sort_quadrant(quadrant)
    end
    @routed_locations = quadrants[0] + quadrants[1] + quadrants[2] + quadrants[3]
  end

  def sort_quadrant(quadrant)
    quadrant.sort do |location_a, location_b|
      # Are location a and location b the nearest neighbour?
      location_a.drive_times[location_b.id.to_sym] <=> location_a.drive_times.values.min
    end
  end

  def get_southest_location
    @locations.min_by(&:latitude)
  end

  def get_northest_location
    @locations.max_by(&:latitude)
  end

  def get_westest_location
    @locations.max_by(&:longitude)
  end

  def get_eastest_location
    @locations.min_by(&:longitude)
  end

  def get_middle_point(x, y)
    (x.to_f + y.to_f)/2.0
  end

end
