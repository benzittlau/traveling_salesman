class Processor
  SETS = %w[starbucks subway]
  SAMPLE_SIZE = 30

  def self.geo_code_all_addresses
    SETS.each do |set|
      addresses = File.readlines("address_sets/#{set}_addresses.raw").map(&:strip)

      CSV.open("address_sets/#{set}_geocoded.csv", "w+") do |csv|
        csv << ['latitude', 'longitude', 'address']

        addresses.each do |address|
          location = Here.geocode({
            :searchtext => address
          })

          csv << [location["Latitude"], location["Longitude"], address]
        end
      end
    end
  end

  def self.sample(mode)
    SETS.each do |set|
      addresses = File.readlines("address_sets/#{set}_geocoded.csv")

      File.open("address_sets/#{set}_#{mode}_geocoded_sample.csv", "w+") do |f|
        headers = addresses.shift
        f.puts(headers)
        f.puts(addresses.sample(SAMPLE_SIZE))
      end
    end
  end
  
  def self.build_matrixes(mode)
    SETS.each do |set|

      locations = CSV.read("address_sets/#{set}_#{mode}_geocoded_sample.csv", {:headers => true, :header_converters => :symbol}).map(&:to_hash)

      locations.each_with_index do |location, index|
        location[:combined] = "#{location[:latitude]},#{location[:longitude]}"
        location[:id] = index
      end

      locations.each do |location|

        drive_times = Here.matrix(
          [location[:combined]],
          locations.map{|l| l[:combined]}
        )

        location[:times] = drive_times
      end


      headers = [:id, :latitude, :longitude, :location] + (0..locations.size).to_a

      CSV.open("address_sets/#{set}_#{mode}_sample_matrix.csv",'w',
                  :write_headers => true,
                  :headers => headers) do |csv|

        locations.each do |location|
          csv << [
            location[:id],
            location[:latitude],
            location[:longitude],
            location[:location],
          ] + location[:times]
        end
      end
    end
  end
end
