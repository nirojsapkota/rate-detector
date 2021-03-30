#!/usr/bin/env ruby
require 'csv'

# require_relative 'utils/utility_functions'
require_relative 'reading'
require 'byebug'
require 'date'

# File Handler class
class FileHandler
  attr_accessor :filename, :rate, :error, :rows_processed

  def initialize(options)
    @filename = options.inputFile
    @rate = options.rate.to_i
    @error = []
    @rows_processed = 0
  end

  # rubocop:todo Metrics/PerceivedComplexity
  # rubocop:todo Metrics/MethodLength
  # rubocop:todo Metrics/AbcSize
  def parse_csv # rubocop:todo Metrics/CyclomaticComplexity
    file = File.open("./#{filename}", 'r')
    comparator = nil
    output_file = File.open("./output-#{filename}", 'w')
    current = {}

    CSV.foreach(file, headers: true, skip_blanks: true).with_index do |row, ind|
      row_obj = Reading.new(row)

      if row_obj.clean_data
        @rows_processed += 1
        # add the first row to comparator
        if ind.zero?
          comparator = row_obj
          next
        end
        # compare the comparator with current row
        # row_obj = Reading.new(row)
        rate_per_min = rate_per_minutes(comparator, row_obj)
        if rate_per_min > rate
          if rate_per_min == current[:rate]
            # merge with previous data
            current[:time_to] = row['Timestamp']
            current[:volume_to] = row['Volume']
          else
            output_file.write(format_data(current)) unless current.empty? # rubocop:todo Metrics/BlockNesting
            current = { time_from: comparator.time_stamp, time_to: row_obj.time_stamp,
                        volume_from: comparator.volume, volume_to: row_obj.volume, rate: rate_per_min }
          end
        end
        comparator = row_obj
      end
    end
    # insert the last value
    output_file.write(format_data(current))
  rescue StandardError => e
    @error << e
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity

  def rate_per_minutes(start_obj, end_obj)
    time_diff = time_diff_in_min(start_obj, end_obj)
    volum_diff = (end_obj.volume - start_obj.volume).abs
    volum_diff / time_diff
  end

  def time_diff_in_min(start_obj, end_obj)
    (end_obj.parse_time.to_i - start_obj.parse_time.to_i).to_f / 60
  end

  def format_data(h_ash)
    h_ash.tap { |k| k.delete(:rate) }.values.to_csv
  end
end
