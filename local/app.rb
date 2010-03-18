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

  def with_presenter(event, &block)
    if !event.presenter_name.nil?
      block.call
    end
  end

  def builder(template, options = {}, &block)
    super(template, options.merge(render_options(:builder, template)), &block)
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

get "/events/*" do
  set_from_config(:google_analytics_code)
  @event = Event.find_by_path(File.join(params[:splat]))
  cache haml(:event)
end

get "/posts.xml" do
  content_type :xml, :charset => "utf-8"
  @posts = Post.find_articles[0..9]
  cache builder(:posts)
end

get "/events.xml" do
  content_type :xml, :charset => "utf-8"
  @events = Event.upcoming
  cache builder(:events)
end
