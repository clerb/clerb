require File.join(File.dirname(__FILE__), "event_factory")
require File.join(File.dirname(__FILE__), "spec_helper")

describe "Event" do
  include EventFactory

  before(:each) do
    stub_configuration
  end

  after(:each) do
    remove_fixtures
    FileModel.purge_cache
  end

  it "should be findable" do
    create_event(:title => "Event1")
    Event.find_all.should have(1).item
  end

  it "should find by path" do
    create_event(:heading => "My event", :path => "events/my-event")
    Event.find_by_path("my-event").heading.should == "My event"
  end

  it "should find next event" do
    create_event(:heading => "Past event",
                 :metadata => { "date" => "February 22, 2010" },
                 :path => "events/past-event")
    create_event(:heading => "Next event",
                 :metadata => { "date" => "May 24, 2010" },
                 :path => "events/next-event")
    create_event(:heading => "Not next event",
                 :metadata => { "date" => "June 22, 2010" },
                 :path => "events/not-next-event")
    Event.next(Date.parse("March 14, 2010")).heading.should == "Next event"
  end

end
