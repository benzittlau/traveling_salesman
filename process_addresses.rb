require 'bundler'
Bundler.require(:default)
Dotenv.load

require './lib/processor'
require './lib/here'

Processor.build_matrixes
