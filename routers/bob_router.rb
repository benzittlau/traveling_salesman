class BobRouter < BaseRouter
  def route
    binding.pry
    @routed_locations = @locations.sort_by(&:latitude)
  end
end
