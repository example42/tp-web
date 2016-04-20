class CreateKeyValues < ActiveRecord::Migration
  def change
    create_table :key_values do |t|
      t.string :type
      t.string :key
      t.string :value
      t.references :keyable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
