require 'sinatra/tilt'

module Tilt
  # Vpim template implementation. See:
  # http://vpim.rubyforge.org/
  class IcalTemplate < Template
    def initialize_engine
      return if defined?(::Vpim)
      require_template_library 'ri_cal'
      require 'tzinfo'
    end

    def prepare
    end

    def evaluate(scope, locals, &block)
      if data.respond_to?(:to_str)
        cal = RiCal.Calendar
        cal.prodid = "Cleveland Ruby Brigade"
        locals[:cal] = RiCal::Component::ComponentBuilder.new(cal)
        super(scope, locals, &block)
      elsif data.kind_of?(Proc)
        cal = RiCal.Calendar(&data)
      end
      cal.to_s
    end

    def precompiled_template(locals)
      data.to_str
    end
  end
  register 'ical', IcalTemplate


end
