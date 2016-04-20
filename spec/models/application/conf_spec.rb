require 'test_helper'

class Application::ConfTest < ActiveSupport::TestCase
  context "#generate_hash" do
    context "default conf" do
      setup do
        @app = Application.new(name: 'apache')
        @conf = described_class.new(name: nil, options_hash: {port: 80, option_b: 'js'}, application: @app)
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache" => {
            "template"=>"site/apache/httpd.conf.erb",
            "options_hash"=>{:port=>80, :option_b=>"js"}
          }
        })
      end
    end

    context "non default conf" do
      setup do
        @app = Application.new(name: 'apache')
        @conf = described_class.new(name: 'mime.types', template: 'site/apache/httpd.conf.erb', options_hash: {port: 80, option_b: 'js'}, application: @app)
      end

      should "generate the right hash" do
        @conf.generate_hash.must_equal({
          "apache::mime.types" => {
            "template"=>"site/apache/httpd.conf.erb",
            "options_hash"=>{:port=>80, :option_b=>"js"}
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