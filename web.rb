require 'sinatra'
require 'raw_data'


get '/' do
  @data ||= RawData.new
  @data.fund_names.map {|name| "<a href='/#{name}'>#{name}</a>"}.join("<\p>")
end

get '/:fund' do
  @data ||= RawData.new
  @data.fund(params[:fund]).gvis
end
