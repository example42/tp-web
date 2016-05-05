# == Schema Information
#
# Table name: applications
#
#  auto_repo     :boolean
#  created_at    :datetime         not null
#  data_module   :string
#  debug_dir     :string
#  debug_enable  :boolean
#  ensure        :string
#  id            :integer          not null, primary key
#  manifest_id   :integer
#  name          :string
#  puppi_enable  :boolean
#  test_enable   :boolean
#  test_template :string
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_applications_on_manifest_id  (manifest_id)
#

class Application < ActiveRecord::Base
  belongs_to :manifest
  has_many :confs
  has_many :dirs
  has_one :puppi
  accepts_nested_attributes_for :confs, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :dirs, reject_if: :all_blank, allow_destroy: true
  after_initialize :default_values

  has_many :options_hash, as: :keyable, class_name: 'KeyValue::OptionsHash'
  accepts_nested_attributes_for :options_hash, reject_if: :all_blank, allow_destroy: true

  has_many :settings_hash, as: :keyable, class_name: 'KeyValue::SettingsHash'
  accepts_nested_attributes_for :settings_hash, reject_if: :all_blank, allow_destroy: true

  after_create :load_options

  def generate_install_hash
    hash = {}
    puppet_attributes.keys.each do |attr|
      hash[attr] = self.send(attr) unless self.send(attr).blank?
    end
    hash['options_hash'] = generate_type_hash('options') unless options_hash.empty?
    hash['settings_hash'] = generate_type_hash('settings') unless settings_hash.empty?
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
    def load_options
      load_file_template
      load_file_options
    end

    def load_file_template
      template = tiny_data.file_template
      return if template.nil?
      confs.create!(name: 'init', template_content: template)
    end

    def load_file_options
      file_options = tiny_data.file_options
      return if file_options.nil?
      init_file = confs.find_by(name: 'init')
      file_options.each_pair do |k, v|
        init_file.options_hash.create!(key: k, value: v)
      end
    end

    def generate_type_hash(type)
      type_hash = {}
      send("#{type}_hash").each do |element|
        type_hash[element.key] = element.value
      end
      type_hash
    end

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
