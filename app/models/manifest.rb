# == Schema Information
#
# Table name: manifests
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  updated_at :datetime         not null
#

class Manifest < ActiveRecord::Base
  has_many :applications

  def available_apps
    TinyData.all
  end

  def to_manifest
    manifest = {}
    manifest = generate_install_hash(manifest)
    manifest = generate_conf_hash(manifest)
    manifest = generate_dir_hash(manifest)
    manifest.to_yaml
  end

  private
    def generate_install_hash(manifest)
      install_hash = {}
      applications.each { |app| install_hash[app.name] = app.generate_install_hash }
      manifest["tp::install_hash"] = install_hash unless install_hash.empty?
      manifest
    end

    def generate_conf_hash(manifest)
      conf_hash = {}
      applications.each do |app|
        app.generate_conf_hash(conf_hash)
      end
      manifest["tp::conf_hash"] = conf_hash unless conf_hash.empty?
      manifest
    end

    def generate_dir_hash(manifest)
      dir_hash = {}
      applications.each do |app|
        app.generate_dir_hash(dir_hash)
      end
      manifest["tp::dir_hash"] = conf_hash unless dir_hash.empty?
      manifest
    end
end
