require "generators/errdo/errdo_generator"
require "generators/active_record/errdo_generator"

require 'test_helper'

class ErrdoGeneratorTest < Rails::Generators::TestCase

  tests Errdo::Generators::ErrdoGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  # should "default to name 'error'" do
  #   run_generator
  #   assert_migration "db/migrate/errdo_create_errors.rb", /def change/
  # end

end
