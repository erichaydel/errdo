require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class ErrdoGenerator < ActiveRecord::Generators::Base

      TableAlreadyExistsError = Class.new(Thor::Error)

      argument :attributes, type: :array, default: [], banner: "field:type field:type"
      source_root File.expand_path("../templates", __FILE__)

      def check_table_not_exists
        if model_exists_in_db?
          raise TableAlreadyExistsError, <<-ERROR
            Seems that this model name already exists in the database (Or the name MODEL_instance exists)
            Please choose a different name and retry!
            ERROR
        end
      end

      def copy_errdo_migration
        migration_template "migration.rb", "db/migrate/errdo_create_#{table_name}.rb"
      end

      private

      def instance_table_name
        "#{file_path}_instances"
      end

      def model_exists_in_db?
        ActiveRecord::Base.connection.table_exists? table_name
        ActiveRecord::Base.connection.table_exists? "#{file_path}_instances"
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5?
      end

    end
  end
end
