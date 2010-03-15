require 'lib/event'
require 'lib/post'

set :haml, { :format => :html5, :escape_html => true, :attr_wrapper => '"' }

helpers do
  def partial(template, params={})
    if params.key?(:collection)
      collection_partial template, params.delete(:collection), params.delete(:object), params
    else
      haml template, :layout => false, :escape_html => false, :locals => params
    end
  end

  def collection_partial(template, collection, object_name, params={})
    collection.map do |object|
      params.merge!(object_name => object)
      haml template, :layout => false, :escape_html => false, :locals => params
    end.join
  end

  def pretty_date(date)
    date.strftime("%B %e, %l:%M %P")
  end
end

get "/" do
  set_from_config(:google_analytics_code)
  @next_event = Event.next
  @posts = Post.find_all[0..10]
  cache haml(:index)
end
