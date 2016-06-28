class FunkyRouter < BaseRouter
  def route
    @routed_locations = []
    #starting_point = get_starting_point(@locations)
    starting_point = get_other_starting_point
    weighted_average(starting_point, @locations)
  end

  def get_starting_point(locations)
    id = locations.map do |v|
      [v.id.to_i, sum_array(v.drive_times.values)]
    end.sort_by{|v| v[1]}.first[0]
    locations[id]
  end

  def get_other_starting_point
    sorted = @locations.map do |l|
      [l.id, [l.drive_times.max_by{|k,v| v}, l.drive_times.reject{|k,v| v.zero?}.min_by{|k,v| v}]]
    end.to_h
    @locations[sorted.min_by{|k, v| v[0][1]}[0].to_i]
  end

  def weighted_average(sp, order)
    remaining_locations = order.clone

    next_loc = remaining_locations.delete(sp)

    while (!remaining_locations.empty?) do
      @routed_locations << next_loc

      next_loc = shortest_destination(next_loc, remaining_locations)
      remaining_locations.delete(next_loc)
    end
    @routed_locations << next_loc
  end

  def shortest_destination(source, remaining)
    r_ids = remaining.map(&:id)
    sums = remaining.map{|v| [v.id, sum_array(v.drive_times.select{|x| r_ids.include?(x.to_s)}.values)]}.to_h
    remaining.sort_by{|d| source.drive_time_to(d) - (sums[d.id] / remaining.length.to_f)}.first
  end

  def sum_array(arr)
    arr.inject(0, :+)
  end
end
