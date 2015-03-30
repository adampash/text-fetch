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

      expect(article.text.split(" ")[0...2].join(" ")).to eq "It's difficult,"
      expect(article.title).to eq(
        "Who Has More Clout at NYC's Top Restaurants: Brian Williams or Geraldo?"
      )
      # puts article.text
      # require 'pry'; binding.pry
      expect(article.md5).to eq "a84d280cd9ddff5da26c4ba2c676532f"
      expect(article.author).to eq "Alex Pareene"
      # expect(article[:images].length).to eq 1
    end
  end

  it "takes a URL and selector and returns that article/text" do
    VCR.use_cassette("selector_fetch") do
      article = Article.fetch("http://www.tedcruz.org/record/our-standard-the-constitution/", selector: "html body div div section div div div div div.box.record")

      expect(
        # article[:text][:markdown].split(" ")[0...2].join(" ")
        article.text.split(" ")[0...2].join(" ")
      ).to eq "## Our"
      expect(article.title).to eq("Our Standard: The Constitution - Ted Cruz")
      puts article.text
      expect(article.md5).to eq "ee9e1f96c1ba3ae9a4dc45cf7d0a0719"
      expect(article.author).to eq nil
    end
  end

  it "strips out tabs and line breaks from html" do
    html = "\n\n<p>This\n\t
      is          some text</p>"
    expect(Article.clean(html)).to eq "<p>This is some text</p>"
  end

  it "converts to markdown as expected" do
    html = "\n\n<h1>This is a headline</h1><p>This\n\t
      is          some text</p>"
    expect(Article.markdownify(html)).to eq "# This is a headline\n\nThis is some text"

    # html = "This is a headline and <a href=\"http://example.com\">here is text </a>okay?"
    # expect(Article.markdownify(html)).to eq "This is a headline and [here is text ](http://example.com)okay?"
  end
end
