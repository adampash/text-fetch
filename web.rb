require 'sinatra'
# require "sinatra/jsonp"
require 'httparty'
require 'json'
require_relative './lib/article'

POST_API = "http://kinja.com/api/core/post"

post '/' do
  params = JSON.parse(request.body.read)
  Article.fetch(params["url"], {format: params["format"]}).to_json
end
