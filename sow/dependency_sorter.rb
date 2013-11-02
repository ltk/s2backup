module Sow
  class DependencySorter
    attr_reader :items

    def initialize(items)
      @items = items.to_a
    end

    def sorted_items
      sorted_tags.map do |tag|
        tag_dictionary[tag]
      end
    end

    private

    class MissingDependencyError < StandardError
      attr_reader :original
      def initialize(msg, original=nil);
        super(msg);
        @original = original;
      end
    end

    class CircularDependencyError < StandardError
      attr_reader :original
      def initialize(msg, original=nil);
        super(msg);
        @original = original;
      end
    end

    def tag_dictionary
      @tag_dictionary ||= begin
        {}.tap do |hash|
          items.each do |item|
            hash[item.dependency_tag] = item
          end
        end
      end
    end

    def dependency_hash
      @dependency_hash ||= begin
        TsortableHash.new.tap do |hash|
          items.each do |item|
            hash[item.dependency_tag] = item.dependencies
          end
        end
      end
    end

    def sorted_tags
      dependency_hash.tsort
    rescue TSort::Cyclic => e
      match = /\[(?<entries>.*)\]/.match e.message
      entries = match[:entries].gsub('"', '').split(', ')
      sow_records = entries.map do |entry|
        entry_info = /^(?<table>[^\d]+)_(?<id>[\d]+)/.match entry
        "sow_record(#{entry_info[:table].classify}, #{entry_info[:id]})"
      end
      raise CircularDependencyError.new("#{sow_records} contain circular dependencies.", e)
    end

    class TsortableHash < Hash
      include TSort

      alias tsort_each_node each_key

      def tsort_each_child(node, &block)
        fetch(node).each(&block)
      rescue KeyError => e
        node_info = /^(?<table>[^\d]+)_(?<id>[\d]+)/.match node

        raise MissingDependencyError.new("No defined entry for 'sow_record(#{node_info[:table].classify}, #{node_info[:id]})'.", e)
      end
    end
  end
end
