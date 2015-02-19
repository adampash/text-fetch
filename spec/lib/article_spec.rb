require_relative '../../lib/article'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

describe Article do
  it "takes a URL and returns the text of an article and a hash" do
    VCR.use_cassette("post_fetch") do
      article = Article.fetch("http://gawker.com/1686159467")

      expect(
        article[:text][:markdown].split(" ")[0...2].join(" ")
      ).to eq "It's difficult,"
      expect(article[:title]).to eq(
        "Who Has More Clout at NYC's Top Restaurants: Brian Williams or Geraldo?"
      )
      expect(article[:hash]).to eq "b109392644602167b1c127d77282534d"
      expect(article[:author]).to eq "Alex Pareene"
      expect(article[:images].length).to eq 1
    end
  end

  it "strips out tabs and line breaks from html" do
    html = "<p>This
      is          some text</p>"
    expect(Article.clean(html)).to eq "<p>This is some text</p>"
  end
end
