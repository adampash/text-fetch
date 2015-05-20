require 'sinatra'
require 'json'
require 'sinatra/cross_origin'

require_relative './lib/article'

configure do
  enable :cross_origin
end

post '/' do
  unless params["selector"].nil?
    params["selector"] = nil if params["selector"].strip.empty?
  end
  puts params
  article = Article.fetch(params["url"], {
    format: params["format"],
    selector: params["selector"]
  })

  content_type :json
  if params.has_key? "md5"
    # require 'pry'; binding.pry
    if params[:md5] == article.md5
      return { md5: article.md5 }.to_json
    end
  end
  article.as_json
end
