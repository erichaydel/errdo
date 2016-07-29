require 'test_helper'

require "generators/active_record/errdo_generator"

class ActiveRecordGeneratorTest < Rails::Generators::TestCase

  tests ActiveRecord::Generators::ErrdoGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  should "make sure that migrations are produced" do
    run_generator %w(err)
    assert_migration "db/migrate/errdo_create_errs.rb", /def change/
  end

end
