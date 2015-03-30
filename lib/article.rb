require 'mechanize'
require 'readability'
require 'reverse_markdown'
require 'textract'

class Article
  def self.fetch(url, opts={})
    Textract.get_text(url, opts[:selector])
  end

  def self.markdownify(text)
    ReverseMarkdown.convert(clean text).strip
  end

  def self.clean(html)
    html.gsub(/[\s]+/, ' ').strip
  end

  private
  def self.get(url, selector=nil)
    agent = Mechanize.new
    page = agent.get url
    page = page.at(selector) unless selector.nil?
    page.content
  end

  def self.generate_hash(text)
    if text.nil?
      unique_hash = 'NO TEXT'
    else
      unique_hash = Digest::MD5.hexdigest text
    end
  end

end
