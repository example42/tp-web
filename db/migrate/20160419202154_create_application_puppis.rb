class CreateApplicationPuppis < ActiveRecord::Migration
  def change
    create_table :application_puppis do |t|
      t.string :ensure
      t.boolean :check_enable
      t.string :check_template
      t.boolean :info_enable
      t.string :info_template
      t.boolean :info_defaults
      t.boolean :log_enable
      t.string :data_module
      t.boolean :verbose
      t.references :application, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
