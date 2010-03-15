require File.join(File.dirname(__FILE__), 'models')

class Post < Page

  def self.model_path(basename=nil)
    params = [Nesta::Configuration.page_path, "posts"]
    params << basename if basename
    File.join(*params)
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
