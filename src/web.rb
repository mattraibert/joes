require 'sinatra'
require 'interesting_statement_factory'

get '/' do
  @data ||= InterestingStatementFactory.new.read_data_from_files
  @data.fund_names.map {|name| "<a href='/#{name}'>#{name}</a>"}.join("<\p>")
end

get '/csv' do
  content_type "application/octet-stream"
  @data ||= InterestingStatementFactory.new.read_data_from_files
  @data.csv
end

get '/:fund' do
  @data ||= InterestingStatementFactory.new.read_data_from_files
  @data.fund(params[:fund]).gvis
end
