class SortingRouter < BaseRouter
  def route
    min_time = Float::INFINITY

    @routed_locations = []
    remaining_locations = @locations.clone

    remaining_locations.sort_by! { |x| Math.sqrt(x.latitude.to_f * x.latitude.to_f + x.longitude.to_f * x.longitude.to_f) }

    next_location = remaining_locations.shift

    while (!remaining_locations.empty?) do
      @routed_locations << next_location

      next_location = shortest_destination(next_location, remaining_locations)
      remaining_locations.delete(next_location)
    end

    @routed_locations << next_location

    next_location = shortest_destination(next_location, remaining_locations)
    remaining_locations.delete(next_location)

  end

  def shortest_destination(source, remaining_destinations)
    remaining_destinations.sort_by { |d| source.drive_time_to(d) }.first
  end
end
