class Application::Conf < ActiveRecord::Base
  belongs_to :application

  serialize :options_hash, Hash
  serialize :settings_hash, Hash

  def generate_hash
    hash = {}
    puppet_attributes.keys.each do |attr|
      if name.nil? and attr == "template"
        hash["template"] = template_name
      else
        hash[attr] = self.send(attr) unless self.send(attr).blank?
      end
    end
    final_hash = {}
    final_hash[hash_name] = hash unless hash.empty?
    final_hash
  end

  private
    def hash_name
      return application.name if name.nil?
      "#{application.name}::#{name}"
    end

    def puppet_attributes
      puppet = attributes
      %w(id name application_id created_at updated_at).each { |attr| puppet.delete(attr) }
      puppet
    end

    def template_name
      return template unless template.nil?
      return nil if application.nil?
      config_file_path = application.tiny_data.data_for['config_file_path']
      config_file = File.basename config_file_path
      "site/#{application.name}/#{config_file}.erb"
    end
end
