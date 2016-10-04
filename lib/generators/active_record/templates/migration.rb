class ErrdoCreate<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %> do |t|
      t.string :exception_class_name
      t.string :exception_message
      t.string :http_method
      t.string :host_name
      t.string :url

      t.text :backtrace

      t.string :backtrace_hash
      t.integer :occurrence_count, default: 0
      t.datetime :last_occurred_at

      t.string :last_experiencer_type
      t.integer :last_experiencer_id

      t.integer :status, default: 0
      t.string :importance, default: "error"

<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>

      t.timestamps null: false
    end

    create_table :<%= occurrence_table_name %> do |t|
      t.integer :<%= table_name.singularize %>_id

      t.string :experiencer_type
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

    add_index :<%= table_name %>, :backtrace_hash, unique: true
    add_index :<%= table_name %>, :importance
    add_index :<%= table_name %>, :last_experiencer_id
    add_index :<%= table_name %>, :last_experiencer_type

    add_index :<%= occurrence_table_name %>, :experiencer_id
    add_index :<%= occurrence_table_name %>, :experiencer_type
    add_index :<%= occurrence_table_name %>, :<%= table_name.singularize %>_id
  end
end
