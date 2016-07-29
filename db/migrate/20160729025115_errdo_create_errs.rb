class ErrdoCreateErrs < ActiveRecord::Migration
  def change
    create_table :errs do |t|
      t.text :backtrace

      t.string :backtrace_id
      t.integer :occurrence_count


      t.timestamps null: false
    end

    create_table :err_instances do |t|
      t.integer :err_id

      t.string :experiencer_class
      t.integer :experiencer_id

      t.integer :ocurrence_count
      t.timestamps null: false
    end

    add_index :errs, :backtrace_id, unique: true
    add_index :err_instances, :experiencer_id
    add_index :err_instances, :experiencer_type
    add_index :err_instances, :err_id
  end
end
