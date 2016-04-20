class CreateApplicationDirs < ActiveRecord::Migration
  def change
    create_table :application_dirs do |t|
      t.string :name
      t.string :ensure
      t.string :source
      t.string :vcsrepo
      t.string :base_dir
      t.string :path
      t.string :mode
      t.string :owner
      t.string :group
      t.boolean :config_dir_notify
      t.boolean :config_dir_require
      t.boolean :purge
      t.boolean :recurse
      t.boolean :force
      t.boolean :debug
      t.string :debug_dir
      t.string :data_module
      t.references :application, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
