require 'sinatra'
require 'json'
require_relative './lib/article'

post '/' do
  params = JSON.parse(request.body.read)
  Article.fetch(params["url"], {format: params["format"]}).to_json
end
