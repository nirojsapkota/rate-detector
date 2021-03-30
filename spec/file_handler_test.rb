require 'test/unit/assertions'
require 'csv'
require_relative '../file_handler'
include Test::Unit::Assertions # rubocop:todo Style/MixinUsage

describe FileHandler do
  let(:inputObj) { double(inputFile: 'test.csv', rate: 100) }
  let(:obj) { described_class.new(inputObj) }

  it 'properly initializes the file' do
    expect(obj.filename).to eq 'test.csv'
  end

  it 'validates the existence of file' do
    allow(inputObj).to receive(:inputFile) { 'nonexisting.csv' }
    expect(obj.filename).to eq 'nonexisting.csv'
  end

  let(:file_like_object) { double('2019-04-29 10:03:20,2019-04-29 10:04:00,9100,9400') }
  it 'parses valid csv' do
    allow(inputObj).to receive(:inputFile) { 'sample_test.csv' }
    obj.parse_csv
    expect(obj.rows_processed).to eq 4
  end
end
