starbucks_addresses = File.readlines('starbucks_addresses')

File.open("starbucks_20_addresses", "w+") do |f|
  f.puts(starbucks_addresses.sample(20))
end

subway_addresses = File.readlines('subway_addresses')

File.open("subway_20_addresses", "w+") do |f|
  f.puts(subway_addresses.sample(20))
end

