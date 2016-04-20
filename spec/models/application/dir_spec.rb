require 'test_helper'

class Application::DirTest < ActiveSupport::TestCase
  context "#generate_hash" do
    context "certs conf" do
      setup do
        @app = Application.new(name: 'apache')
        @conf = described_class.new(name: 'certs', ensure: 'present', path: '/etc/pki/ssl/', source: 'puppet:///modules/site/certs/', recurse: true, purge: true, application: @app)
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache::certs" => {
            'ensure' => 'present',
            'path' => "/etc/pki/ssl/",
            'source' => "puppet:///modules/site/certs/",
            'recurse' => true,
            'purge' => true
          }
        })
      end
    end

    context "courtesy conf" do
      setup do
        @app = Application.new(name: 'apache')
        @conf = described_class.new(name: 'courtesy_site', ensure: 'present', path: '/var/www/courtesy_site', source: 'https://git.site.com/www/courtesy_site', vcsrepo: 'git', application: @app)
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache::courtesy_site" => {
            'ensure' => 'present',
            'path' => "/var/www/courtesy_site",
            'source' => "https://git.site.com/www/courtesy_site",
            'vcsrepo' => 'git'
          }
        })
      end
    end

    context "empty conf" do
      setup do
        @app = Application.new(name: 'apache')
        @conf = described_class.new
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({})
      end
    end
  end
end