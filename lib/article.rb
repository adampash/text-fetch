require 'mechanize'
require 'readability'
require 'reverse_markdown'

class Article
  def self.fetch(url, opts={})
    opts[:format] = opts[:format] || 'markdown'
    article = Readability::Document.new(
      get(url),
      {
        remove_empty_nodes: true,
        tags: %w(p div a img ul ol li blockquote table tr td),
        :attributes => %w(src href),
        blacklist: '#read-only-warning'
      }
    )
    text = article.content
    response = {
      title: article.title,
      text: {
      },
      hash: generate_hash(text),
      author: article.author,
      images: article.images
    }
    if opts[:format] == 'markdown'
      response[:text][:markdown] = ReverseMarkdown.convert(text)
    else
      response[:text][:html] = text
    end
    response
  end

  private
  def self.get(url)
    agent = Mechanize.new
    page = agent.get url
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
