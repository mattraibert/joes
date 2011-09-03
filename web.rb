require 'sinatra'
require 'raw_data'

get '/' do
  @data ||= RawDataFactory.new.read_data_from_files
  @data.fund_names.map {|name| "<a href='/#{name}'>#{name}</a>"}.join("<\p>")
end

get '/csv' do
  content_type "application/octet-stream"
  @data ||= RawDataFactory.new.read_data_from_files
  @data.csv
end

get '/:fund' do
  @data ||= RawDataFactory.new.read_data_from_files
  @data.fund(params[:fund]).gvis
end
