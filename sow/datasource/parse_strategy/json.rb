module Sow
  module Datasource
    module ParseStrategy
      class Json < Base
        def to_hash
          JSON.load(data_io)
        end
      end
    end
  end
end
