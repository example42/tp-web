class Application::Puppi < ActiveRecord::Base
  belongs_to :application

  serialize :options_hash, Hash
  serialize :settings_hash, Hash

  def generate_hash
  end
end
