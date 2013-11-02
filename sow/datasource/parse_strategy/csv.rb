module Sow
  module Datasource
    module ParseStrategy
      class Csv < Base
        def to_hash
          { :entries => entries }
        end

        private

        def entries
          [].tap do |entries|
            CSV.foreach(data_io, headers: :first_row, skip_blanks: true) do |row|
              entries << row.to_hash
            end
          end
        end
      end
    end
  end
end
