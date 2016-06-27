class LatitudeRouter < BaseRouter
  def route
    @routed_locations = @locations.sort_by(&:latitude)
  end
end
