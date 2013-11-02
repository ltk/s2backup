module Sow
  class SeededRecordStore
    include Singleton

    class SeededRecordNotFoundError < StandardError;end

    def save(record, seed_id)
      records_of_klass(record.class)[seed_id] = record
    end

    def get(klass, seed_id)
      records_of_klass(klass)[seed_id] || raise(SeededRecordNotFoundError, "Record for class #{klass} and seed_id #{seed_id} could not be found.")
    end

    private

    def records_of_klass(klass)
      records[klass.name.tableize.to_sym] ||= {}
    end

    def records
      @records ||= {}
    end
  end
end
