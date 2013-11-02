module Sow
  class Instructions
    attr_reader :seed_factory

    delegate :klass, :to => :seed_factory

    def initialize(seed_factory)
      @seed_factory = seed_factory
    end

    def data
      @data ||= to_hash.with_indifferent_access
    end

    def entries
      data[:entries] || []
    end

    def options
      data[:options] || {}
    end

    private

    def to_hash
      Datasource::Parser.parse(seed_data_file, parse_strategy)
    end

    def parse_strategist
      @parse_strategist ||= Datasource::ParseStrategist.new(klass)
    end

    def parse_strategy
      @parse_strategy ||= seed_factory.options.delete(:parse_strategy) || parse_strategist.parse_strategy
    end

    def seed_data_file
      seed_directory.join(parse_strategist.seed_data_file)
    end
  end
end
