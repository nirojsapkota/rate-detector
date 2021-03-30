#!/usr/bin/env ruby
require 'optparse'
require 'pp'
require './file_handler'
require 'ostruct'

# parse_options class
class RateDetector
  #
  # Return a structure describing the @options.
  #
  def initialize
    @options = OpenStruct.new
  end

  def parse(args)
    @options.inputFile = args.first
    @options.rate = args.last

    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: ./command.rb client.csv'
      opts.separator ''
    end

    opt_parser.parse!(args)
    @options
  end
end

parse_option = RateDetector.new
options = parse_option.parse(ARGV)
filehandler = FileHandler.new(options)
filehandler.parse_csv if options.inputFile && !options.inputFile.empty?
