module Sow
  class SeedFactory
    attr_reader :klass, :options

    def initialize(klass, options = {})
      raise ArgumentError, 'First argument must be a Class' unless klass.is_a? Class

      @klass = klass
      @options = options
    end

    def new_seeds
      instructions.entries.map do |entry|
        new_seed(entry)
      end
    end

    private

    def new_seed(entry_definition)
      Seed.new(klass, entry_definition, seed_option_set)
    end

    def seed_option_set
      @seed_option_set ||= SeedOptionSet.new(instructions.options.merge(options))
    end

    def instructions
      @instructions ||= Instructions.new(self)
    end
  end
end
