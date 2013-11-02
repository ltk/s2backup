module Sow
  module Datasource
    class ParseStrategist
      attr_reader :klass, :seed_data_file

      def initialize(klass)
        @klass = klass
        find_seed_data_file
      end

      def parse_strategy
        unless seed_data_file
          raise MissingSeedDataFileError, "No seed data file could be found for the #{klass} class."
        end

        unless parsable_extensions.include? seed_data_file_extension
          raise UnparsableDataFormatError, "#{seed_data_file} is not of a parsable format."
        end

        parse_strategy_for_extension(seed_data_file_extension)
      end

      private

      def find_seed_data_file
        @seed_data_file = seed_data_files.detect do |filename|
          filename =~ /^#{klass.to_s.tableize}\./
        end
      end

      def seed_data_file_extension
        File.extname(seed_data_file)
      end

      def seed_data_files
        Dir.entries(seed_directory)
      end

      def parsable_extensions
        ['.yml', '.csv']
      end

      def parse_strategy_for_extension(extension)
        strategy_type = extension.sub('.', '').gsub('.', '_').classify
        "Sow::Datasource::ParseStrategy::#{strategy_type}".constantize
      end
    end
  end
end
