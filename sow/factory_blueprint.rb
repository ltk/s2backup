module Sow
  class FactoryBlueprint
    def initialize(klass, options = {})
      @klass = klass
      @options = options
    end

    def to_factory
      SeedFactory.new(klass, options)
    end

    private
    attr_reader :klass, :options
  end
end
