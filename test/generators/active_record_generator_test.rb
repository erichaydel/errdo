require 'test_helper'
require 'minitest/mock'
require "generators/active_record/errdo_generator"

class ActiveRecordGeneratorTest < Rails::Generators::TestCase

  tests ActiveRecord::Generators::ErrdoGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  should "make sure that migrations are produced" do
    run_generator %w(err)
    assert_migration "db/migrate/errdo_create_errs.rb", /def change/
  end

  should "throw error if table name already exists" do
    capture(:stderr) do
      assert_raises Exception do
        ActiveRecord::Base.connection.stub(:table_exists?, true) do
          run_generator %w(err)
        end
      end
      assert_no_migration "db/migrate/errdo_create_errs.rb"
    end
  end

  should "revoke correctly" do
    run_generator %w(err)
    run_generator %w(err), behavior: :revoke
    assert_no_migration "db/migrate/errdo_create_errs.rb"
  end

end
