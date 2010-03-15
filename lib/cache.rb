
module Sinatra

  # Sinatra Caching module
  #
  #  TODO:: Need to write documentation here
  #
  module Cache

    VERSION = 'Sinatra::Cache v0.2.0'
    def self.version; VERSION; end


    module Helpers

      # Caches the given URI to a html file in /public
      #
      # <b>Usage:</b>
      #    >> cache( erb(:contact, :layout => :layout))
      #      =>  returns the HTML output written to /public/<CACHE_DIR_PATH>/contact.html
      #
      # Also accepts an Options Hash, with the following options:
      #  * :extension => in case you need to change the file extension
      #
      #  TODO:: implement the opts={} hash functionality. What other options are needed?
      #
      def cache(content, opts={})
        if options.cache_enabled
          headers 'Cache-Control' => 'public, max-age=300'
        end

        content
      end

      def page_cached_timestamp
        "<!-- page cached: #{Time.now.strftime("%Y-%d-%m %H:%M:%S")} -->\n" if options.cache_enabled
      end

    end #/module Helpers


    # Sets the default options:
    #
    #  * +:cache_enabled+ => toggle for the cache functionality. Default is: +true+
    #
    def self.registered(app)
      app.helpers(Cache::Helpers)
      app.set :cache_enabled, true
    end

  end #/module Cache

  register(Sinatra::Cache)

end #/module Sinatra
