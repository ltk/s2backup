module Sow
  class DirectiveCollection
    def initialize(directives)
      @directives = directives.to_a
    end

    def to_factories
      directives.map do |directive|
        factory_from_directive(directive)
      end
    end

    private

    class InvalidDirectiveError < StandardError;end

    attr_reader :directives

    def factory_from_directive(directive)
      if directive.respond_to? :to_factory
        directive.to_factory
      elsif directive.class == Class
        FactoryBlueprint.new(directive).to_factory
      else
        raise InvalidDirectiveError, "#{directive} is not a valid sow directive."
      end
    end
  end
end
