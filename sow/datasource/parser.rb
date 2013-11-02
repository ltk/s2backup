module Sow
  module Datasource
    class Parser
      def self.parse(file, parse_strategy_class)
        #arg errors if bad input
        io = File.open(file)
        parse_strategy_class.new(io).to_hash
      ensure
        io.close
      end
    end
  end
end
