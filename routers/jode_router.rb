class JodeRouter < BaseRouter
  def route
    @routed_locations = []
    remaining_locations = @locations.clone

    longest_location=nil
    longestMinimum=0

    remaining_locations.each{
        |location| shortestDist = location.drive_times.sort_by{|x| x}[1][1]
      if(shortestDist > longestMinimum)
        longest_location = location
        longestMinimum = shortestDist
      end
    }

    remaining_locations.delete longest_location
    next_location = remaining_locations.shift

    while(!remaining_locations.empty?) do
      @routed_locations << next_location

      next_location = shortest_destination(next_location, remaining_locations)
      remaining_locations.delete(next_location)
    end
  end


  def route2
    @routed_locations = []
    remaining_locations = @locations.clone

    longest_location=nil
    longestMinimum=0

    remaining_locations.each{
        |location| shortestDist = location.drive_times.sort_by{|x| x}[1][1]
      if(shortestDist > longestMinimum)
        longest_location = location
        longestMinimum = shortestDist
      end
    }

    next_locations= Array.new
    remaining_locations.delete longest_location
    next_location = remaining_locations.shift

    while(!remaining_locations.empty?) do
      @routed_locations << next_locations[0]
      @routed_locations << next_locations[1]

      next_locations = shortest_clustered_path(next_location, remaining_locations)
#      next_location = shortest_destination(next_location, remaining_locations)
      remaining_locations.delete(next_locations[0])
      remaining_locations.delete(next_locations[1])
    end
  end


  def shortest_destination(source, remaining_destinations)
    remaining_destinations.
      sort_by{|d| source.drive_time_to(d)}.
      first
  end


  def shortest_clustered_path(source, remaining_destinations)
    foo_destinations = remaining_destinations.clone
    foo_destinations.delete(source)

    shortestDist=100000000000
    shortestPaths=[]
    remaining_destinations.each {
      |location|
        nd_foo_destinations = foo_destinations.clone
        nd_foo_destinations.delete(location)
        pathDist = location.drive_time_to(source)
        shortest2ndPath = shortest_destination(location, nd_foo_destinations)
        pathDist += shortest2ndPath.drive_times.values.sort[2]

      if(pathDist < shortestDist )
        shortestDist = pathDist
        shortestPaths=[location, shortest2ndPath]
      end

    }

    shortestPaths
=begin
    foo_destinations = remaining_destinations.clone
    pathLength=0

    shortestPath1 = shortest_destination(source, foo_destinations_)
    pathLength += source.drive_times.values.sort[3]
    foo_destinations.delete shortestPath1

    shortestPath2 = shortest_destination(source, foo_destinations_)
    pathLength += source.drive_times.values.sort[3]
    foo_destinations.delete shortestPath2
=end
  end

 end
