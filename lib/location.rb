class Location
  attr_accessor :address, :name

  def initialize(name, address)
    @name = name
    @address = address
  end

  class << self

    def find_by_name(name)
      locations = raw_list
      from_hash(name, locations)
    end

    def raw_list
      YAML.load(File.read(Nesta::Configuration.locations_path))
    end

    def from_hash(name, hash)
      location = hash.fetch(name)
      Location.new(name, location['address'])
    end

  end

end
