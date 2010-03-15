require 'lib/event'

set :haml, { :format => :html5, :escape_html => true, :attr_wrapper => '"' }

helpers do
  def partial(template, params={})
    haml template, :layout => false, :escape_html => false, :locals => params
  end
end

get "/" do
  set_from_config(:google_analytics_code)
  @next_event = Event.next
  cache haml(:index)
end
