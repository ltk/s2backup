module Sow
  module Datasource
    module ParseStrategy
      class Yml < Base
        def to_hash
          YAML.load(data_io)
        end
      end
    end
  end
end
