require 'test_helper'

class TinyDataTest < ActiveSupport::TestCase
  context ".all" do
    should "contains apache" do
      all = described_class.all
      all.size.must_equal 107
      all.must_include 'apache'
    end
  end

  context "apache" do
    setup do
      @apache = described_class.new('apache')
    end

    context "#hiera_configs" do
      should "return osfamily and default for hiera configs" do
        array = @apache.hiera_configs
        array.must_include 'osfamily'
        array.must_include 'default'
        array.size.must_equal 2
      end
    end

    context "#options_for" do
      should "return distros for osfamily" do
        array = @apache.options_for('osfamily')
        array.must_include 'Debian'
        array.must_include 'FreeBSD'
        array.must_include 'RedHat'
        array.must_include 'Suse'
       array.size.must_equal 4
      end
    end

    context "#data_for" do
      should "return default" do
        hash = @apache.data_for
        hash.keys.size.must_equal 12
        hash['package_name'].must_equal 'httpd'
      end

      should "return debian for osfamily" do
        hash = @apache.data_for(osfamily: 'Debian')
        hash.keys.size.must_equal 18
        hash['package_name'].must_equal 'apache2' # this is from Debian
        hash['tcp_port'].must_equal '80'          # this is from default
      end

      should "raise exception for unknown" do
        err = ->{ @apache.data_for(foo: 'Debian') }.must_raise Exception
        err.message.must_equal "invalid key foo for hiera hierarchy"
      end
    end
  end

  context "motd" do
    setup do
      @motd = described_class.new('motd')
    end

    context "#hiera_configs" do
      should "return osfamily and default for hiera configs" do
        array = @motd.hiera_configs
        array.must_include 'lsbdistcodename'
        array.must_include 'operatingsystem'
        array.must_include 'default'
        array.size.must_equal 3
      end
    end

    context "#options_for" do
      should "return distros for lsb dist code name" do
        array = @motd.options_for('lsbdistcodename')
        array.must_include 'wheezy'
        array.size.must_equal 1
      end
      should "return OSes for operatingsystem" do
        array = @motd.options_for('operatingsystem')
        array.must_include 'Debian'
        array.must_include 'Solaris'
        array.size.must_equal 2
      end
    end

    context "#data_for" do
      should "return default" do
        hash = @motd.data_for
        hash.keys.size.must_equal 1
        hash['config_file_path'].must_equal '/etc/motd'
      end

      should "return data using wheezy for lsbdistcodename" do
        hash = @motd.data_for(lsbdistcodename: 'wheezy')
        hash.keys.size.must_equal 1
        hash['config_file_path'].must_equal '/etc/motd' # this is from wheezy
      end

      should "return data using lsbdistcodename: wheezy and operatingsystem: Debian" do
        hash = @motd.data_for(lsbdistcodename: 'wheezy', operatingsystem: 'Debian')
        hash.keys.size.must_equal 1
        hash['config_file_path'].must_equal '/etc/motd.last' # this is from Debian
      end

      should "raise exception for unknown" do
        err = ->{ @motd.data_for(foo: 'Debian') }.must_raise Exception
        err.message.must_equal "invalid key foo for hiera hierarchy"
      end
    end
  end
end
