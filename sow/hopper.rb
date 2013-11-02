module Sow
  class Hopper
    attr_reader :entries

    def initialize(entries)
      @entries = entries.to_a
    end

    # def to_a
    #   entries
    # end

    def sort
      @entries = DependencySorter.new(@entries).sorted_items
    end

    private

    attr_writer :entries
  end
end
