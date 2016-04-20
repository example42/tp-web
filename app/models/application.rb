class Application < ActiveRecord::Base
  belongs_to :manifest
  has_many :confs
  has_many :dirs
  has_one :puppi
  after_initialize :default_values

  def generate_install_hash
    hash = {}
    puppet_attributes.keys.each do |attr|
      hash[attr] = self.send(attr) unless self.send(attr).blank?
    end
    hash
  end

  def generate_conf_hash(hash = {})
    return hash if confs.count == 0
    confs.each do |conf|
      hash.merge! conf.generate_hash
    end
    hash
  end

  def generate_dir_hash(hash = {})
    return hash if dirs.count == 0
    dirs.each do |dir|
      hash.merge! dir.generate_hash
    end
    hash
  end

  def tiny_data
    TinyData.new(name)
  end

  private
    def default_values
      if new_record?
        self.ensure = 'present' if self.ensure.nil?
      end
    end

    def puppet_attributes
      puppet = attributes
      %w(id name manifest_id created_at updated_at).each { |attr| puppet.delete(attr) }
      puppet
    end
end
