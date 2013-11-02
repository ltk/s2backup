module Sow
  class SeedOptionSet
    delegate :[], :to => :@options

    def initialize(options = {})
      @options = options
    end
  end
end
