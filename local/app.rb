require 'lib/event'
require 'lib/post'
require 'lib/tilt/ical_template'

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

  def page_wrapper(&block)
    page_class = "page"
    page_class << eval("if defined?(page_class) then ' %s' % page_class end", block.binding).to_s
    haml_tag(:div, :class => page_class, &block)
  end
end

get "/" do
  set_from_config(:google_analytics_code)
  next_event = Event.next
  grouped_posts = Post.find_articles[0..9].to_set.classify { |p| p.date.strftime("%B %e, %Y") }
  resources = Post.find_sticky_resources
  cache haml(:index, :locals => { :next_event => next_event, :grouped_posts => grouped_posts, :resources => resources })
end

get "/resources" do
  set_from_config(:google_analytics_code)
  grouped_resources = Post.find_resources.to_set.classify { |r| r.topic }
  cache haml(:resources, :locals => { :grouped_resources => grouped_resources })
end

def ical(template=nil, options={}, locals={}, &block)
  template = Proc.new { block } if template.nil?
  render :ical, template, options.merge(render_options(:ical, template)), locals
end

get "/events" do
  set_from_config(:google_analytics_code)
  upcoming_events = Event.upcoming
  past_events = Event.past
  cache haml(:events, :locals => { :upcoming_events => upcoming_events, :past_events => past_events })
end

get "/events/*" do
  set_from_config(:google_analytics_code)
  event = Event.find_by_path(File.join(params[:splat]))
  cache haml(:event, :locals => { :event => event, :page_class => "event" })
end

get "/posts/*" do
  set_from_config(:google_analytics_code)
  post = Post.find_by_path(File.join(params[:splat]))
  cache haml(:post_full, :locals => { :post => post, :page_class => "post" })
end

get "/posts.xml" do
  content_type :xml, :charset => "utf-8"
  @posts = Post.find_articles[0..9]
  cache builder(:posts)
end

mime_type :calendar, 'text/calendar'

get "/events.ics" do
  content_type :calendar, :charset => "utf-8"
  @events = Event.upcoming
  cache ical(:events)
end
