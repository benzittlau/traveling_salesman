require 'bundler'
Bundler.require(:default)
Dotenv.load

require './lib/processor'
require './lib/here'

mode = "benchmark"
Processor.sample(mode)
Processor.build_matrixes(mode)
