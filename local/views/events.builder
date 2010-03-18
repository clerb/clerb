xml.instruct!
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  xml.title "The Cleveland Ruby Brigade: Events", :type => "text"
  xml.id atom_id
  xml.link :href => "#{base_url}/events.xml", :rel => "self"
  xml.link :href => base_url, :rel => "alternate"
  xml.author do
    xml.name "The Cleveland Ruby Brigade"
    xml.uri "http://www.clerb.org"
    xml.email "info@clerb.org"
  end
  @events.each do |event|
    xml.entry do
      xml.title event.title
      xml.link :href => url_for(event),
               :type => "text/html",
               :rel => "alternate"
      xml.id atom_id(event)
      xml.content event.body, :type => "html"
      xml.published event.date(:xmlschema)
    end
  end
end
