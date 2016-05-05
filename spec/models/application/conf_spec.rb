# == Schema Information
#
# Table name: application_confs
#
#  application_id      :integer
#  base_dir            :string
#  config_file_notify  :boolean
#  config_file_require :boolean
#  content             :string
#  created_at          :datetime         not null
#  data_module         :string
#  debug               :boolean
#  debug_dir           :string
#  ensure              :string
#  epp                 :string
#  group               :string
#  id                  :integer          not null, primary key
#  mode                :string
#  name                :string
#  options             :text
#  owner               :string
#  path                :string
#  source              :string
#  template            :string
#  template_content    :text
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_application_confs_on_application_id  (application_id)
#

require 'test_helper'

class Application::ConfTest < ActiveSupport::TestCase
  context "validate uniqueness name" do
    setup do
      @apache = Application.create!(name: 'apache')
      @ps = Application.create!(name: 'puppetserver')
    end

    should "allow duplicated name on different application" do
      @apache.confs.create!(name: 'foo')
      err = ->{ @apache.confs.create!(name: 'foo') }.must_raise ActiveRecord::RecordInvalid
      err.message.must_match /Name has already been taken on this application/
    end

    should "not allow duplicated name on same application" do
      @apache.confs.create!(name: 'foo')
      @ps.confs.create!(name: 'foo').valid?.must_equal true
    end
  end

  context "#generate_hash" do
    context "default conf" do
      setup do
        @app = Application.create(name: 'apache')
        @conf = described_class.create(name: nil, application: @app)
        @conf.options_hash.create(key: 'port', value: 80)
        @conf.options_hash.create(key: 'option_b', value: 'js')
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache" => {
            "template"=>"site/apache/httpd.conf.erb",
            "options_hash"=>{'port'=>'80', 'option_b'=>"js"}
          }
        })
      end
    end

    context "non default conf" do
      setup do
        @app = Application.create(name: 'apache')
        @conf = described_class.create(name: 'mime.types', template: 'site/apache/httpd.conf.erb', application: @app)
        @conf.options_hash.create(key: 'port', value: 80)
        @conf.options_hash.create(key: 'option_b', value: 'js')
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache::mime.types" => {
            "template"=>"site/apache/httpd.conf.erb",
            "options_hash"=>{'port'=>'80', 'option_b'=>"js"}
          }
        })
      end
    end

    context "empty conf" do
      setup do
        @app = Application.new(name: 'apache')
        @conf = described_class.new(application: @app)
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache"=>{
            "template"=>"site/apache/httpd.conf.erb"
            }
          })
      end
    end
  end
end
