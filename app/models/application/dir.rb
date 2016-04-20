# == Schema Information
#
# Table name: application_dirs
#
#  application_id     :integer
#  base_dir           :string
#  config_dir_notify  :boolean
#  config_dir_require :boolean
#  created_at         :datetime         not null
#  data_module        :string
#  debug              :boolean
#  debug_dir          :string
#  ensure             :string
#  force              :boolean
#  group              :string
#  id                 :integer          not null, primary key
#  mode               :string
#  name               :string
#  owner              :string
#  path               :string
#  purge              :boolean
#  recurse            :boolean
#  source             :string
#  updated_at         :datetime         not null
#  vcsrepo            :string
#
# Indexes
#
#  index_application_dirs_on_application_id  (application_id)
#

class Application::Dir < ActiveRecord::Base
  belongs_to :application

  has_many :settings_hash, as: :keyable, class_name: 'KeyValue::SettingsHash'
  accepts_nested_attributes_for :settings_hash, reject_if: :all_blank, allow_destroy: true

  def generate_hash
    hash = {}
    puppet_attributes.keys.each do |attr|
      hash[attr] = self.send(attr) unless self.send(attr).blank?
    end
    hash['settings_hash'] = generate_type_hash('settings') unless settings_hash.empty?
    final_hash = {}
    final_hash[hash_name] = hash unless hash.empty?
    final_hash
  end

  private
    def generate_type_hash(type)
      type_hash = {}
      send("#{type}_hash").each do |element|
        type_hash[element.key] = element.value
      end
      type_hash
    end

    def hash_name
      "#{application.name}::#{name}"
    end

    def puppet_attributes
      puppet = attributes
      %w(id name application_id created_at updated_at).each { |attr| puppet.delete(attr) }
      puppet
    end
end
