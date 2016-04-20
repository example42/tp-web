# == Schema Information
#
# Table name: applications
#
#  auto_repo     :boolean
#  created_at    :datetime         not null
#  data_module   :string
#  debug_dir     :string
#  debug_enable  :boolean
#  ensure        :string
#  id            :integer          not null, primary key
#  manifest_id   :integer
#  name          :string
#  puppi_enable  :boolean
#  test_enable   :boolean
#  test_template :string
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_applications_on_manifest_id  (manifest_id)
#

require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  context "default values" do
    should "set ensure present" do
      described_class.new.ensure.must_equal "present"
    end

    should "not touch when specified" do
      described_class.new(ensure: 'absent').ensure.must_equal "absent"
    end
  end

  context "#generate_install_hash" do
    should "generate hash" do
      app = described_class.create(name: 'apache')
      app.generate_install_hash.must_equal({"ensure"=>"present"})
    end

    should "include install hash" do
      app = described_class.create(name: 'apache')
      app.options_hash.create(key: 'foo', value: 'bar')
      app.options_hash.create(key: 'baz', value: 'xyz')
      app.generate_install_hash.must_equal({
        "ensure"=>"present",
        "options_hash" => {
          "foo" => "bar",
          "baz" => "xyz"
        }
      })
    end

    should "include settings hash" do
      app = described_class.create(name: 'apache')
      app.settings_hash.create(key: 'foo', value: 'bar')
      app.settings_hash.create(key: 'baz', value: 'xyz')
      app.generate_install_hash.must_equal({
        "ensure"=>"present",
        "settings_hash" => {
          "foo" => "bar",
          "baz" => "xyz"
        }
      })
    end
  end

  context "#generate_conf_hash" do
    should "generate empty hash when empty confs" do
      app = described_class.create(name: 'apache')
      app.generate_conf_hash.must_equal({})
    end

    should "generate hash when has confs" do
      app = described_class.create(name: 'apache')
      app.confs.create
      app.generate_conf_hash.must_equal({
        "apache"=>{
          "template"=>"site/apache/httpd.conf.erb"
        }
      })
    end
  end

  context "#generate_dir_hash" do
    should "generate hash when has dirs" do
      app = described_class.create(name: 'apache')
      app.generate_dir_hash.must_equal({})
    end

    should "generate hash when has confs" do
      app = described_class.create(name: 'apache')
      app.dirs.create(name: 'courtesy_site', ensure: 'present', path: '/var/www/courtesy_site', source: 'https://git.site.com/www/courtesy_site', vcsrepo: 'git')
      app.generate_dir_hash.must_equal({
        "apache::courtesy_site"=>{
          "ensure"=>"present",
          "source"=>"https://git.site.com/www/courtesy_site",
          "vcsrepo"=>"git",
          "path"=>"/var/www/courtesy_site"
        }
      })
    end
  end

  context "#tiny_data" do
    should "return a tiny data" do
      app = described_class.create(name: 'apache')
      app.tiny_data.class.must_equal TinyData
      app.tiny_data.instance_variable_get(:@application).must_equal "apache"
    end
  end
end
