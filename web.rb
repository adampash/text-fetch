require 'sinatra'
require 'json'
require 'sinatra/cross_origin'

require_relative './lib/article'

configure do
  enable :cross_origin
end

post '/' do
  # puts params
  # params = JSON.parse(request.body.read)
  # puts params
  Article.fetch(params["url"], {
    format: params["format"],
    selector: params[:selector]
  }).to_json
end

post '/check' do
  # params = JSON.parse(request.body.read)
  article = Article.fetch(params["url"], {
    format: 'html', selector: params["selector"]
  })
  {
    hash: article[:hash]
  }.to_json
end
