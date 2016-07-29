class ErrdoCreate<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %> do |t|
      t.text :backtrace

      t.string :backtrace_id
      t.integer :occurrence_count

<% attributes.each do |attribute| -%>
      t.<%= attribute.type %> :<%= attribute.name %>
<% end -%>

      t.timestamps null: false
    end

    create_table :<%= instance_table_name %> do |t|
      t.integer :<%= table_name.singularize %>_id

      t.string :experiencer_class
      t.integer :experiencer_id

      t.integer :ocurrence_count
      t.timestamps null: false
    end

    add_index :<%= table_name %>, :backtrace_id, unique: true
    add_index :<%= instance_table_name %>, :experiencer_id
    add_index :<%= instance_table_name %>, :experiencer_type
    add_index :<%= instance_table_name %>, :<%= table_name.singularize %>_id
  end
end
