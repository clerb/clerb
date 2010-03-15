require File.join(File.dirname(__FILE__), 'models')

class Event < Page
  alias :title :heading

  class << self

    def next(today=Date.today)
      upcoming.first
    end

    def upcoming(today=Date.today)
      Event.find_all.reject do |event|
        event.date < today
      end.sort do |a,b|
        a.date <=> b.date
      end
    end

    def past(today=Date.today)
      Event.find_all.reject do |event|
        event.date > today
      end
    end

    def model_path(basename=nil)
      params = [Nesta::Configuration.page_path, "events"]
      params << basename if basename
      File.join(*params)
    end

  end

  def presenter_name
    @presenter_name ||= metadata("presenter")
  end

  def presenter_bio
    @presenter_bio ||= metadata("presenter_bio")
  end

  def location
    @location ||= metadata("location")
  end

  def location_address
    @location_address ||= metadata("location_address")
  end

  def blurb
    @blurb ||= metadata("blurb")
  end

end
