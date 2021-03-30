require 'test/unit/assertions'
require 'csv'
require_relative '../reading'
include Test::Unit::Assertions # rubocop:todo Style/MixinUsage

describe Reading do
  let!(:r_headers) { %w[Timestamp Volume] }
  let!(:r_data) { ['2019-04-29 10:01:00', ''] }
  let!(:invalid_row) { CSV::Row.new(r_headers, r_data) }
  let!(:start_dtime) { '2019-04-29 10:01:00' }
  let!(:start_data) { CSV::Row.new(r_headers, [start_dtime, '9010']) }

  let(:obj) { described_class.new(start_data) }

  it 'properly initializes the class' do
    expect(obj.data).to eq start_data
  end

  it 'parses time' do
    expect(obj.parse_time.to_s).to eq('2019-04-29 10:01:00 +0000')
  end

  it 'returns volume integer' do
    expect(obj.volume).to eq 9010
  end
end
