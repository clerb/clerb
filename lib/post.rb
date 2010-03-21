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

  def comments_enabled?
    @comments_enbaled ||= metadata("comments")
  end

  def url
    @url ||= metadata("url")
  end

  def from
    formatted_metadata("from")
  end

end
