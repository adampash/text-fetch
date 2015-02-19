require 'sinatra'
require 'json'
require_relative './lib/article'

post '/' do
  puts params
  params = JSON.parse(request.body.read)
  puts params
  Article.fetch(params["url"], {format: params["format"]}).to_json
end

post '/check' do
  params = JSON.parse(request.body.read)
  article = Article.fetch(params["url"], {format: 'html'})
  {
    hash: article[:hash]
  }.to_json
end
