require 'test_helper'

class GenerateYamlTest < ActionController::TestCase
  setup do
    @yaml =
'---
tp::install_hash:
  memcache:
    ensure: present
  apache:
    ensure: present
  mysql:
    ensure: present
tp::conf_hash:
  apache:
    template: site/apache/httpd.conf.erb
    options_hash:
      port: 80
      option_b: js
  apache::mime.types:
    template: site/apache/mime.types.erb
    options_hash:
      option_a: js
  mysql:
    template: site/mysql/my.cnf.erb
    options_hash:
      port: 9191
      option_c: js
'

    @manifest = Manifest.create!
    # apache
    @apache = Application.create!(name: 'apache')
    # add file
    @file = Application::Conf.create!
    @file.options_hash = { 'port' => 80, 'option_b' => 'js' }
    @apache.confs << @file
    @apache.confs.create!(name: 'mime.types', template: 'site/apache/mime.types.erb', options_hash: {'option_a' => 'js'})

    @mysql = Application.create!(name: 'mysql')
    @mysql.confs.create!(options_hash: {'port' => 9191, 'option_c' => 'js'})

    @memcache = Application.create!(name: 'memcache')
    @manifest.applications = [@memcache, @apache, @mysql]
  end
  should "generate right yaml" do
    @manifest.to_manifest.must_equal @yaml
  end
end
