class UpdateColumns < ActiveRecord::Migration
  def up
      change_column :errors, :exception_class_name, :text
      change_column :errors, :exception_message, :text
      change_column :errors, :host_name, :text
      change_column :errors, :url, :text
      change_column :error_occurrences, :user_agent, :text
      change_column :error_occurrences, :query_string, :text
  end
  def down
      change_column :errors, :exception_class_name, :string
      change_column :errors, :exception_message, :string
      change_column :errors, :host_name, :string
      change_column :errors, :url, :string
      change_column :error_occurrences, :user_agent, :string
      change_column :error_occurrences, :query_string, :string
  end
end
