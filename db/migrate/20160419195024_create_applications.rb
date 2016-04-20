class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string  :name
      t.string  :ensure
      t.text    :options_hash
      t.text    :settings_hash
      t.boolean :auto_repo
      t.boolean :puppi_enable
      t.boolean :test_enable
      t.string  :test_template
      t.boolean :debug_enable
      t.string  :debug_dir
      t.string  :data_module

      t.references :manifest, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
