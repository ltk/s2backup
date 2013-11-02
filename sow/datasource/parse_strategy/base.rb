module Sow
  module Datasource
    module ParseStrategy
      class Base
        attr_reader :data_io

        def initialize(data_io)
          @data_io = data_io
        end

        def to_json
          raise NotImplementedError, 'Parse strategies must implement #to_json'
        end
      end
    end
  end
end
