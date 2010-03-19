require File.join(File.dirname(__FILE__), 'models')

class Post < Page

  class << self

    def model_path(basename=nil)
      params = [Nesta::Configuration.page_path, "posts"]
      params << basename if basename
      File.join(*params)
    end

    def find_resources
      find_all.select { |post| post.topic }.
        sort { |x, y| y.date <=> x.date }
    end

    def find_sticky_resources
      find_resources.select { |post| post.sticky? }
    end

  end

  def permalink
    "/posts/%s" % super
  end

  def topic
    @topic ||= metadata("topic")
  end

  def sticky?
    @sticky ||= metadata("sticky")
  end

  def url
    @url ||= metadata("url")
  end

  def from
    if from_text = metadata("from")
      case @format
      when :textile
        RedCloth.new(from_text).to_html
      else
        Maruku.new(from_text).to_html
      end.gsub(%r{<p>(.*)</p>}, '\1')
    end
  end

end
