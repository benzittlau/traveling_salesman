class NearestRouter < BaseRouter
  def route
    @routed_locations = []
    remaining_locations = @locations.clone

    next_location = remaining_locations.shift

    while(!remaining_locations.empty?) do
      @routed_locations << next_location

      next_location = shortest_destination(next_location, remaining_locations)
      remaining_locations.delete(next_location)
    end
  end

  def shortest_destination(source, remaining_destinations)
    remaining_destinations.
      sort_by{|d| source.drive_time_to(d)}.
      first
  end
end
