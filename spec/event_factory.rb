require File.join(File.dirname(__FILE__), "model_factory")

module EventFactory
  include ModelFactory

  def create_event(options={}, &block)
    o = {
      :path => "events/my-event",
      :title => "My event",
      :body => "Body goes here",
      :metadata => {
        "date" => "May 24, 2010",
        "presenter" => "John Doe",
        "presenter_bio" => "Bio goes here",
        "location" => "Somewhere",
        "location_address" => "1234 Main St."
      }.merge(options.delete(:metadata) || {})
    }.merge(options)
    create_page(o, &block)
  end

end
