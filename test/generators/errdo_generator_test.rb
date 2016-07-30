require "generators/errdo/errdo_generator"
require 'test_helper'

class ErrdoGeneratorTest < Rails::Generators::TestCase

  tests Errdo::Generators::ErrdoGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination
  setup :make_initializer

  should "add class name to initializer" do
    run_generator %w(err)
    assert_file "config/initializers/errdo.rb", /config.error_name = :err/
  end

  private

  def make_initializer
    mkdir_p "#{destination_root}/config/initializers/"
    File.open("#{destination_root}/config/initializers/errdo.rb", 'w') do |file|
      file.write("Errdo.setup do |config|\nend")
    end
  end

end
