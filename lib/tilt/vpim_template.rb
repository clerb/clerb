require 'sinatra/tilt'

module Tilt
  # Vpim template implementation. See:
  # http://vpim.rubyforge.org/
  class VpimTemplate < Template
    def initialize_engine
      return if defined?(::Vpim)
      require_template_library 'vpim/icalendar'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      cal = Vpim::Icalendar.create2
      if data.respond_to?(:to_str)
        locals[:cal] = cal
        super(scope, locals, &block)
      elsif data.kind_of?(Proc)
        cal.instance_eval(&data)
      end
      cal.encode
    end

    def precompiled_template(locals)
      data.to_str
    end
  end
  register 'vpim', VpimTemplate


end
