require 'date'
require 'byebug'
REQUIRED_KEYS = %w[Timestamp Volume].freeze

# Reading class
class Reading
  attr_accessor :rate_per_min, :data

  def initialize(data)
    @data = data
    # @rate_per_min = rate_per_minutes(start_data, end_data)
  end

  def time_stamp
    data['Timestamp']
  end

  def clean_data
    REQUIRED_KEYS.each do |r|
      return nil if data[r].nil? || data[r].empty?
    end
  end

  def parse_time
    d = DateTime.parse(data['Timestamp'])
    d.to_time
  end

  def volume
    data['Volume'].to_i
  end
end
