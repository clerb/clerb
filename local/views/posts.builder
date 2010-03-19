xml.instruct!
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do
  xml.title "The Cleveland Ruby Brigade: Posts", :type => "text"
  xml.id atom_id
  xml.link :href => "#{base_url}/posts.xml", :rel => "self"
  xml.link :href => base_url, :rel => "alternate"
  xml.author do
    xml.name @author["name"] if @author["name"]
    xml.uri @author["uri"] if @author["uri"]
    xml.email @author["email"] if @author["email"]
  end if @author
  @posts.each do |post|
    xml.entry do
      xml.title post.heading
      xml.link :href => post.url,
               :type => "text/html",
               :rel => "alternate"
      xml.id atom_id(post)
      xml.content partial(:feed_post, :post => post), :type => "html"
      xml.published post.date(:xmlschema)
      post.categories.each do |category|
        xml.category :term => category.permalink
      end
    end
  end
end
