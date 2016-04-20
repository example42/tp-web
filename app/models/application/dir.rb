class Application::Dir < ActiveRecord::Base
  belongs_to :application

  serialize :settings_hash, Hash

  def generate_hash
    hash = {}
    puppet_attributes.keys.each do |attr|
      hash[attr] = self.send(attr) unless self.send(attr).blank?
    end
    final_hash = {}
    final_hash[hash_name] = hash unless hash.empty?
    final_hash
  end

  private
    def hash_name
      "#{application.name}::#{name}"
    end

    def puppet_attributes
      puppet = attributes
      %w(id name application_id created_at updated_at).each { |attr| puppet.delete(attr) }
      puppet
    end
end
