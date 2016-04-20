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

require 'test_helper'

class Application::PuppiTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
