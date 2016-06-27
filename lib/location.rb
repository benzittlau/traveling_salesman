class Location
  attr_reader :id, :latitude, :longitude, :combined, :drive_times

  def initialize(params)
    @id = params[:id]
    @latitude = params[:latitude]
    @longitude = params[:longitude]
    @drive_times = {}
    params.each do |key, value|
      if /\d+/.match(key)
        @drive_times[key] = value.to_i
      end
    end
  end

  def combined
    "#{latitude},#{longitude}"
  end

  def drive_time_to(destination)
    @drive_times[destination.id.to_sym]
  end
end
