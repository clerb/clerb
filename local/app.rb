require 'lib/event'
require 'lib/post'

set :haml, { :format => :html5, :escape_html => true, :attr_wrapper => '"' }

helpers do
  def partial(template, params={})
    if params.key?(:collection)
      collection_partial template, params.delete(:collection), params.delete(:object), params
    else
      haml template, :layout => false, :locals => params
    end
  end

  def collection_partial(template, collection, object_name, params={})
    collection.map do |object|
      params.merge!(object_name => object)
      haml template, :layout => false, :locals => params
    end.join
  end

  def pretty_date(date)
    format = %w(%B %e,)
    format = %w(%B %e %Y,) if date.year != Date.today.year
    format << %w( %l:%M %P)
    date.strftime(format.join(" "))
  end
end

get "/" do
  set_from_config(:google_analytics_code)
  @next_event = Event.next
  @grouped_posts = Post.find_articles[0..9].to_set.classify { |p| p.date.strftime("%B %e, %Y") }
  @resources = Post.find_sticky_resources
  cache haml(:index)
end

get "/resources" do
  set_from_config(:google_analytics_code)
  @grouped_resources = Post.find_resources.to_set.classify { |r| r.topic }
  cache haml(:resources)
end

get "/events" do
  set_from_config(:google_analytics_code)
  @upcoming_events = Event.upcoming
  @past_events = Event.past
  cache haml(:events)
end
