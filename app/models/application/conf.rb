# == Schema Information
#
# Table name: application_confs
#
#  application_id      :integer
#  base_dir            :string
#  config_file_notify  :boolean
#  config_file_require :boolean
#  content             :string
#  created_at          :datetime         not null
#  data_module         :string
#  debug               :boolean
#  debug_dir           :string
#  ensure              :string
#  epp                 :string
#  group               :string
#  id                  :integer          not null, primary key
#  mode                :string
#  name                :string
#  options             :text
#  owner               :string
#  path                :string
#  source              :string
#  template            :string
#  template_content    :text
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_application_confs_on_application_id  (application_id)
#

class Application::Conf < ActiveRecord::Base
  belongs_to :application
  validates :name, uniqueness: { scope: :application_id,
    message: "has already been taken on this application"
  }

  has_many :options_hash, as: :keyable, class_name: 'KeyValue::OptionsHash'
  accepts_nested_attributes_for :options_hash, reject_if: :all_blank, allow_destroy: true

  has_many :settings_hash, as: :keyable, class_name: 'KeyValue::SettingsHash'
  accepts_nested_attributes_for :settings_hash, reject_if: :all_blank, allow_destroy: true

  def generate_hash
    hash = {}
    puppet_attributes.keys.each do |attr|
      if name.nil? and attr == "template"
        hash["template"] = template_name
      else
        hash[attr] = self.send(attr) unless self.send(attr).blank?
      end
    end
    hash['options_hash'] = generate_type_hash('options') unless options_hash.empty?
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
      return application.name if name.nil? or name.empty?
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
