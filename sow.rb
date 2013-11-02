module Sow
  def sow_class_with_options(klass, options = {})
    FactoryBlueprint.new(klass, options)
  end

  def seed_directory
    Rails.root.join('db', 'seeds', sow_environment)
  end

  def sow_environment
    Rails.env
  end

  def sow(directives)
    factories = DirectiveCollection.new(directives).to_factories

    seeds = factories.map do |factory|
      factory.new_seeds
    end.flatten

    hopper = Hopper.new(seeds)
    hopper.sort

    manager = Manager.new(hopper.entries)
    manager.sow
  end

  def sow_record(klass, seed_id)
    SeededRecordStore.instance.get(klass, seed_id)
  end
end

