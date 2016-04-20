# == Schema Information
#
# Table name: key_values
#
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  key          :string
#  keyable_id   :integer
#  keyable_type :string
#  type         :string
#  updated_at   :datetime         not null
#  value        :string
#
# Indexes
#
#  index_key_values_on_keyable_type_and_keyable_id  (keyable_type,keyable_id)
#

class KeyValue < ActiveRecord::Base
  belongs_to :keyable, polymorphic: true
end
