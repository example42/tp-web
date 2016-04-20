# == Schema Information
#
# Table name: application_puppis
#
#  application_id :integer
#  check_enable   :boolean
#  check_template :string
#  created_at     :datetime         not null
#  data_module    :string
#  ensure         :string
#  id             :integer          not null, primary key
#  info_defaults  :boolean
#  info_enable    :boolean
#  info_template  :string
#  log_enable     :boolean
#  updated_at     :datetime         not null
#  verbose        :boolean
#
# Indexes
#
#  index_application_puppis_on_application_id  (application_id)
#

class Application::Puppi < ActiveRecord::Base
  belongs_to :application

  serialize :options_hash, Hash
  serialize :settings_hash, Hash

  def generate_hash
  end
end
