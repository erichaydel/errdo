class ErrdoCreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :exception_class_name
      t.string :exception_message
      t.string :http_method
      t.string :host_name
      t.string :url

      t.text :backtrace

      t.string :backtrace_hash
      t.integer :occurrence_count, default: 0
      t.datetime :last_occurred_at


      t.timestamps null: false
    end

    create_table :error_occurrences do |t|
      t.integer :error_id

      t.string :experiencer_class
      t.integer :experiencer_id

      t.string :ip
      t.string :user_agent
      t.string :referer
      t.string :query_string
      t.text :form_values
      t.text :param_values
      t.text :cookie_values
      t.text :header_values

      t.integer :ocurrence_count, default: 1
      t.timestamps null: false
    end

    add_index :errors, :backtrace_hash, unique: true
    add_index :error_occurrences, :experiencer_id
    add_index :error_occurrences, :experiencer_type
    add_index :error_occurrences, :error_id
  end
end
