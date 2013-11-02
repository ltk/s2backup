module Sow
  class Seed
    attr_reader :record

    def initialize(klass, definition, options)
      @seed_id = definition.delete('seed_id')
      @klass = klass
      @definition = definition
      @options = options
    end

    def dependency_tag
      @dependency_tag ||= "#{@klass.to_s.tableize}_#{seed_id}"
    end

    def dependencies
      [].tap do |dependencies|
        unprocessed_attributes.each do |name, value|
          if value.is_a?(String)
            # Sample value: '<% [sow_record(User, 1), sow_record(Planet, 3)] %>'
            matches = value.scan(/(?<record>sow_record\((?<klass>[A-Z][^,]*), (?<id>[\d]*)\))+/)
            dependencies << matches.map {|match| "#{match[1].tableize}_#{match[2]}" }
          end
        end
      end.flatten.uniq
    end

    def prepare
      if @options['delete_existing_by']
        @klass.delete_all(@options['delete_existing_by'] => attributes[@options['delete_existing_by']])
      end
    end

    def before_seeding

    end

    def after_seeding

    end

    def save_record
      @record = build_record
      @record.save
    end

    def save_to_store
      SeededRecordStore.instance.save(record, seed_id.to_i) if seed_id
    end

    def success_log_text
      "#{@klass.name} with seed_id #{seed_id} successfully saved."
    end

    def error_log_text
      "There was an error saving #{@klass.name} with seed_id #{seed_id}."
    end

    private

    attr_reader :seed_id

    def build_record
      new_or_existing_record.tap do |record|
        attributes.each do |key, value|
          record.send(:"#{key.to_sym}=", value)
        end
      end
    end

    def new_or_existing_record
      if @options['find_existing_by']
        @klass.where(@options['find_existing_by'] => attributes[@options['find_existing_by']]).first_or_initialize
      else
        @klass.new
      end
    end

    def attributes
      @attributes ||= attribute_processor.process
    end

    def unprocessed_attributes
      @definition
    end

    def attribute_processor
      @attribute_processor ||= AttributeProcessor.new(unprocessed_attributes)
    end
  end
end
