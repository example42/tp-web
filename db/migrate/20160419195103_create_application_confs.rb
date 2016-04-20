class CreateApplicationConfs < ActiveRecord::Migration
  def change
    create_table :application_confs do |t|
      t.string :name
      t.string :template
      t.text :options

      t.string  :name
      t.string  :ensure
      t.string  :source
      t.string  :template
      t.string  :epp
      t.string  :content
      t.string  :base_dir
      t.string  :path
      t.string  :mode
      t.string  :owner
      t.string  :group
      t.boolean :config_file_notify
      t.boolean :config_file_require
      t.text    :options_hash
      t.text    :settings_hash
      t.boolean :debug
      t.string  :debug_dir
      t.string  :data_module

      t.references :application, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
